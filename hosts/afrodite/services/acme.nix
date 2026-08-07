{config, inputs, lib, ...}:

let
  values = import ../../../vpn/values.nix { inherit config inputs lib; };

  domain = values.publicDomain;
  subdomains = values.publicSubdomains;
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.groups."acme".members = [ config.services.nginx.user ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "amministrazione@${domain}";

    certs."${domain}" = {
      group = "acme";
      webroot = "/var/lib/acme/acme-challenge";

      extraDomainNames = map (x: "${x}.${domain}") subdomains;
    };
  };
}
