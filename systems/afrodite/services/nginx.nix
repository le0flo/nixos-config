{...}: let
  domainName = "leoflo.me";
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "${domainName}" = {
        useACMEHost = domainName;

        locations = {
          "/".proxyPass = "http://10.69.0.2:9000";
          "/.well-known/acme-challenge/".alias = "/var/lib/acme/acme-challenge/";
        };
      };

      "files.${domainName}" = {
        root = "/srv/files.leoflo.me";
        useACMEHost = domainName;

        locations = {
          "/".extraConfig = ''autoindex on;'';
          "/.well-known/acme-challenge/".alias = "/var/lib/acme/acme-challenge/";
        };
      };

      # Internal (homenet only)
      "home.arpa" = {
        locations."/".return = ''200 "Benvenuto nella rete privata di leo :D"'';
      };

      "music.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9001";
      };

      "images.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9002";
      };

      "papers.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9003";
      };

      "cinema.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9004";
      };

      "torrent.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9005";
      };

      # Internal (public facing)
      "music.home.${domainName}" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations = {
          "/".proxyPass = "http://10.69.0.2:9001";
          "/.well-known/acme-challenge/".alias = "/var/lib/acme/acme-challenge/";
        };
      };

      "cinema.home.${domainName}" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations = {
          "/".proxyPass = "http://10.69.0.2:9004";
          "/.well-known/acme-challenge/".alias = "/var/lib/acme/acme-challenge/";
        };
      };
    };
  };
}
