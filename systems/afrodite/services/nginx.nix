{...}: {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "leoflo.me" = {
        useACMEHost = domainName;
        addSSL = true;

        locations."/".proxyPass = "http://10.67.0.2:9000";
      };

      "files.leoflo.me" = {
        root = "/srv/files.leoflo.me";

        useACMEHost = domainName;
        addSSL = true;

        locations."/".extraConfig = ''autoindex on;'';
      };

      # Homelab (public)
      "music.home.leoflo.me" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations."/".proxyPass = "http://10.67.0.2:9001";
      };

      "cinema.home.leoflo.me" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations."/".proxyPass = "http://10.67.0.2:9004";
      };

      # Homelab (internal)
      "music.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9001";
      };

      "images.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9002";
      };

      "papers.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9003";
      };

      "cinema.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9004";
      };

      "torrent.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9005";
      };
    };
  };
}
