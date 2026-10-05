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
    domain = mkStrOption "Domain" "example.com";
    subdomains = mkListOption types.str "Subdomains" [];
    cfTokenFile = mkStrOption "Cloudflare DNS token file" "/run/secrets/cloudflare";
  };
in {
  options.otis.net.tls = {
    enable = mkBoolOption "Enable TLS certificate authority" false;

    publicAcme = {
      enable = mkBoolOption "Public ACME" false;
      email = mkStrOption "Email" "postmaster@example.com";
      certs = mkListSubOption certOpts "List of certificates" [];
    };

    privateAcme.enable = mkBoolOption "Private ACME" false;
  };

  config = mkMerge [
    {
      security.pki.certificateFiles = [ "${secretsPath}/tls/ca.pem" ];
    }
    (mkIf (cfg.enable && cfg.publicAcme.enable) {
      security.acme = {
        acceptTerms = true;
        defaults = { inherit (cfg.publicAcme) email; };

        certs = listToAttrs (map (x: {
          name = x.domain;
          value = {
            extraDomainNames = map (y: "${y}.${x.domain}") x.subdomains;

            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            credentialFiles."CF_DNS_API_TOKEN_FILE" = x.cfTokenFile;

            group = "public-acme";
            webroot = null;
          };
        }) cfg.publicAcme.certs);
      };

      users.groups."public-acme" = {};
    })
    (mkIf (cfg.enable && cfg.privateAcme.enable) {
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

            oldSAN=$(openssl x509 -in "$WORKDIR/cert.pem" -noout -ext subjectAltName | sed -n 's/^[[:space:]]*DNS://p; s/, DNS:/,/gp' | tail -1)
            newSAN="${domains.private},${concatStringsSep "," (map (x: "${x}.${domains.private}") subdomains.private)}"

            if [ ! "$oldSAN" = "$newSAN" ]; then
              rewrite=0
            fi
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
  ];
}
