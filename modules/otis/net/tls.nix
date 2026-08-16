{config, inputs, lib, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  secretsPath = toString inputs.nixos-secrets;

  net = config.otis.net;
  tls = net.tls;
  domains = net.dns.domains;
  subdomains = net.dns.subdomains;
in {
  options.otis.net.tls = {
    custom.enable = mkEnableOption "Load custom tls certificates";

    server = {
      enable = mkEnableOption "Marks this host as the tls CA";

      email = mkOption {
        type = types.str;
        description = "Email used to manage ACME tls certificates";
        default = "amministrazione@${domains.public}";
      };
    };
  };

  config = mkMerge [
    (mkIf tls.custom.enable {
      security.pki.certificateFiles = [ "${secretsPath}/tls/ca.pem" ];
    })
    (mkIf tls.server.enable {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      users.groups."acme".members = [ config.services.nginx.user ];

      security.acme = {
        acceptTerms = true;
        defaults.email = tls.server.email;

        certs."${domains.public}" = {
          group = "acme";
          webroot = "/var/lib/acme/acme-challenge";

          extraDomainNames = map (x: "${x}.${domains.public}") subdomains.public;
        };
      };
    })
  ];
}
