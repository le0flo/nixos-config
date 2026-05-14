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
        addSSL = true;

        locations."/".proxyPass = "http://10.69.0.2:9000";
      };

      "files.${domainName}" = {
        root = "/srv/files.leoflo.me";

        useACMEHost = domainName;
        addSSL = true;

        locations."/".extraConfig = ''autoindex on;'';
      };

      # Homelab (public facing)
      "music.home.${domainName}" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations."/".proxyPass = "http://10.69.0.2:9001";
      };

      "cinema.home.${domainName}" = {
        useACMEHost = domainName;
        forceSSL = true;

        locations."/".proxyPass = "http://10.69.0.2:9004";
      };
    };
  };
}
