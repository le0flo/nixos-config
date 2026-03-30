{pkgs, ...}: {
  services.bind = {
    enable = true;

    forward = "only";
    forwarders = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    cacheNetworks = [
      "127.0.0.0/8"
      "10.69.0.0/24"
    ];

    zones = {
      "home.arpa" = {
        master = true;

        allowQuery = [
          "127.0.0.0/8"
          "10.69.0.0/24"
        ];

        file = pkgs.writeText "home.arpa" ''
          $TTL 86400

          @ IN SOA ns1.home.arpa. admin.home.arpa. (
            2026031801 ; serial
            3600       ; refresh
            900        ; retry
            604800     ; expire
            86400      ; minimum TTL
          )

          @   IN NS  ns1.home.arpa.
          ns1 IN A   10.69.0.1
          @   IN A   10.69.0.1

          music   IN CNAME @
          images  IN CNAME @
          papers  IN CNAME @
          cinema  IN CNAME @
          torrent IN CNAME @
        '';
      };
    };
  };
}
