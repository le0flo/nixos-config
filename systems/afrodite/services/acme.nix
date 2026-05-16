{config, ...}: {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  users.groups."acme".members = [ config.services.nginx.user ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@leoflo.me";

    certs = {
      "leoflo.me" = {
        group = "acme";
        webroot = "/var/lib/acme/acme-challenge";

        extraDomainNames = [
          "files.leoflo.me"
          "music.home.leoflo.me"
          "cinema.home.leoflo.me"
        ];
      };
    };
  };
}
