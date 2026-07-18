{pkgs, ...}:

let
  website = pkgs.callPackage ../../../website {};
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
      "leoflo.me" = {
        useACMEHost = "leoflo.me";
        addSSL = true;

        root = website;
      };

      "files.leoflo.me" = {
        useACMEHost = "leoflo.me";
        addSSL = true;

        root = "/srv/files";
      };

      # Homelab
      "music.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9001";
      };

      "images.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.69.0.2:9002";
      };

      "papers.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.69.0.2:9003";
      };

      "cinema.home.arpa" = {
        locations."/".proxyPass = "http://10.69.0.2:9004";
      };

      "torrent.home.arpa" = {
        extraConfig = ''
          allow 10.69.0.0/24;
          deny all;
        '';

        locations."/".proxyPass = "http://10.69.0.2:9005";
      };
    };
  };
}
