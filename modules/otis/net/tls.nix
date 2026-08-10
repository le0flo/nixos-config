{config, lib, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types;
in {
  options.otis.net.tls =
    let
      domains = config.otis.net.dns.domains;
    in {
      server = {
        enable = mkEnableOption "Marks this host as the tls CA";

        email = mkOption {
          type = types.str;
          description = "Email used to manage ACME tls certificates";
          default = "amministrazione@${domains.public}";
        };
      };
    };

  config =
    let
      net = config.otis.net;
      
      server = net.tls.server;
      domains = net.dns.domains;
      subdomains = net.dns.subdomains;
    in mkIf server.enable {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      users.groups."acme".members = [ config.services.nginx.user ];

      security.acme = {
        acceptTerms = true;
        defaults.email = server.email;

        certs."${domains.public}" = {
          group = "acme";
          webroot = "/var/lib/acme/acme-challenge";

          extraDomainNames = map (x: "${x}.${domains.public}") subdomains.public;
        };
      };
    };
}
