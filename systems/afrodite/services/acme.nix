{config, ...}: let
  domainName = "leoflo.me";
  acmeGroup = "acme-cert";
in {
  users.groups.${acmeGroup}.members = [
    config.services.caddy.user
    config.services.prosody.user
  ];

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
          "xmpp.${domainName}"
        ];
      };
    };
  };
}
