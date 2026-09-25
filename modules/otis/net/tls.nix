{config, customLib, inputs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    listToAttrs;

  inherit (config.otis.net.dns)
    domains
    subdomains;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption
    mkListOption
    mkListSubOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge
    types;

  cfg = config.otis.net.tls;
  secretsPath = toString inputs.nixos-secrets;

  certOpts.options = {
    domain = mkStrOption "The domain for the certificate" "";
    subdomains = mkListOption types.str "Additional subdomains" [];
  };
in {
  options.otis.net.tls = {
    enable = mkBoolOption "Enable tls handling for public and private network" true;
    role = mkEnumOption [ "client" "server" ] "The role of the host" "client";

    publicAcme = {
      enable = mkBoolOption "Enables the public acme service" false;
      email = mkStrOption "Email used to manage ACME tls certificates" "";
      certs = mkListSubOption certOpts "List of certificates to generate using acme" [];
    };

    privateAcme.enable = mkBoolOption "Enables the private acme service" false;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "client") {
      security.pki.certificateFiles = [ "${secretsPath}/tls/ca.pem" ];
    })
    (mkIf (cfg.role == "server" && cfg.publicAcme.enable) {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      security.acme = {
        acceptTerms = true;
        defaults = { inherit (cfg.publicAcme) email; };

        certs = listToAttrs (map (x: {
          name = x.domain;
          value = {
            group = "public-acme";
            webroot = "/var/lib/acme/acme-challenge";
            extraDomainNames = map (y: "${y}.${x.domain}") x.subdomains;
          };
        }) cfg.publicAcme.certs);
      };

      users.groups."public-acme" = {};
    })
    (mkIf (cfg.role == "server" && cfg.privateAcme.enable) {
      security.pki.certificateFiles = [ "${secretsPath}/tls/ca.pem" ];

      systemd = {
        services."private-acme" = {
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.openssl ];

          serviceConfig.Type = "oneshot";

          script = ''
          WORKDIR=/etc/ssl/certs/${domains.private}

          mkdir -p $WORKDIR

          if [ ! -e $WORKDIR/private.key ]; then
            openssl ecparam -name prime256v1 -genkey -noout -out $WORKDIR/private.key
            chmod 440 $WORKDIR/private.key
          fi

          if [ ! -e $WORKDIR/cert.csr ]; then
            openssl req -new \
              -key $WORKDIR/private.key \
              -out $WORKDIR/cert.csr \
              -subj "/C=IT/CN=${domains.private}"
          fi

          cat > $WORKDIR/cert.ext <<EOF
          basicConstraints=CA:FALSE
          keyUsage=digitalSignature
          extendedKeyUsage=serverAuth
          subjectAltName=DNS:${domains.private},${concatStringsSep "," (map (x: "DNS:${x}.${domains.private}") subdomains.private)}
          EOF

          rewrite=0
          if [ -e $WORKDIR/cert.pem ]; then
            expiry=$(openssl x509 -in $WORKDIR/cert.pem -noout -enddate | cut -d= -f2)
            expiry_epoch=$(date -d "$expiry" +%s)
            now_epoch=$(date +%s)
            rewrite=$(( (expiry_epoch - now_epoch) / 86400 ))
          fi

          if [ $rewrite -lt 1 ]; then
            openssl x509 -req \
              -in $WORKDIR/cert.csr \
              -CA ${secretsPath}/tls/ca.pem \
              -CAkey ${config.age.secretsDir}/tls/ca.key \
              -out $WORKDIR/cert.pem \
              -sha256 \
              -set_serial "0x$(openssl rand -hex 16)" \
              -days 365 \
              -extfile $WORKDIR/cert.ext
          fi

          chown -R root:private-acme $WORKDIR
          '';
        };

        timers."private-acme" = {
          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnCalendar = "hourly";
            Persistent = true;
          };
        };
      };

      system.activationScripts."private-acme".text = ''
      ${config.systemd.package}/bin/systemctl start private-acme.service
      '';

      users.groups."private-acme" = {};
    })
  ]);
}
