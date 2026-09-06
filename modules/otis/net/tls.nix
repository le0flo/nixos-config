{config, customLibs, inputs, lib, ...}:

let
  inherit (config.otis.net.dns)
    domains
    subdomains;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.net.tls;
  secretsPath = toString inputs.nixos-secrets;
in {
  options.otis.net.tls = {
    custom.enable = mkBoolOption "Load custom tls certificates" true;

    server = {
      enable = mkBoolOption "Marks this host as the tls CA" false;
      email = mkStrOption "Email used to manage ACME tls certificates" "amministrazione@${domains.public}";
    };
  };

  config = mkMerge [
    (mkIf cfg.custom.enable {
      security.pki.certificateFiles = [ "${secretsPath}/tls/ca.pem" ];
    })
    (mkIf cfg.server.enable {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      users.groups."acme".members = [
        config.services.dovecot2.settings.mail_uid
        config.services.nginx.user
        config.services.postfix.user
      ];

      security.acme = {
        acceptTerms = true;
        defaults.email = cfg.server.email;

        certs."${domains.public}" = {
          group = "acme";
          webroot = "/var/lib/acme/acme-challenge";

          extraDomainNames = map (x: "${x}.${domains.public}") subdomains.public;
        };
      };
    })
  ];
}
