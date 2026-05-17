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
        useACMEHost = "leoflo.me";
        addSSL = true;

        locations."/".proxyPass = "http://10.67.0.2:9000";
      };

      "files.leoflo.me" = {
        root = "/srv/files.leoflo.me";

        useACMEHost = "leoflo.me";
        addSSL = true;

        locations."/".extraConfig = ''autoindex on;'';
      };

      # Homelab
      "music.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9001";
      };

      "images.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.67.0.2:9002";
      };

      "papers.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.67.0.2:9003";
      };

      "cinema.home.arpa" = {
        locations."/".proxyPass = "http://10.67.0.2:9004";
      };

      "torrent.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.67.0.2:9005";
      };
    };
  };
}
