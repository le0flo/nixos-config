{config, ...}: let
  domainName = "leoflo.me";
  acmeGroup = "acme-cert";
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.groups.${acmeGroup}.members = [ config.services.nginx.user ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${domainName}";

    certs = {
      "${domainName}" = {
        group = acmeGroup;
        webroot = "/var/lib/acme/acme-challenge";

        extraDomainNames = [
          "files.${domainName}"
          "music.home.${domainName}"
          "cinema.home.${domainName}"
        ];
      };
    };
  };
}
