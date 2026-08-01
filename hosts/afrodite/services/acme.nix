{config, inputs, lib, ...}:

let
  publicDomain = (import ../../../vpn/values.nix { inherit config inputs lib; }).publicDomain;
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.groups."acme".members = [ config.services.nginx.user ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "amministrazione@${publicDomain}";

    certs."${publicDomain}" = {
      group = "acme";
      webroot = "/var/lib/acme/acme-challenge";

      extraDomainNames = [ "files.${publicDomain}" ];
    };
  };
}
