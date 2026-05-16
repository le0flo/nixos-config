{pkgs, ...}: let
  homeArpaZone = entrypoint: pkgs.writeText "home.arpa-${entrypoint}" ''
    $TTL 86400

    @ IN SOA ns1.home.arpa. admin.home.arpa. (
      2026031801 ; serial
      3600       ; refresh
      900        ; retry
      604800     ; expire
      86400      ; minimum TTL
    )

    @   IN NS  ns1.home.arpa.
    ns1 IN A   ${entrypoint}
    @   IN A   ${entrypoint}

    music   IN CNAME @
    images  IN CNAME @
    papers  IN CNAME @
    cinema  IN CNAME @
    torrent IN CNAME @
  '';
in {
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.bind = {
    enable = true;

    forward = "only";
    forwarders = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    cacheNetworks = [
      "127.0.0.0/8"
      "10.67.0.0/24"
      "10.69.0.0/24"
      "10.96.0.0/24"
    ];

    extraConfig = ''
      view "home-67" {
        match-clients { 127.0.0.0/8; 10.67.0.0/24; };

        zone "home.arpa" {
          type master;
          file "${homeArpaZone "10.67.0.1"}";
          allow-query { 127.0.0.0/8; 10.67.0.0/24; };
          allow-transfer { none; };
        };
      };

      view "home-69" {
        match-clients { 10.69.0.0/24; };

        zone "home.arpa" {
          type master;
          file "${homeArpaZone "10.69.0.1"}";
          allow-query { 10.69.0.0/24; };
          allow-transfer { none; };
        };
      };

      view "home-96" {
        match-clients { 10.96.0.0/24; };

        zone "home.arpa" {
          type master;
          file "${homeArpaZone "10.96.0.1"}";
          allow-query { 10.96.0.0/24; };
          allow-transfer { none; };
        };
      };
    '';
  };
}
