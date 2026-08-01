{lib, pkgs, ...}:

let
  domain = (import ../../../vpn/values.nix {}).privateDomain;
  networks = (import ../../../vpn/values.nix {}).networks;
  
  makeZone = entrypoint: pkgs.writeText "${domain}-${entrypoint}" ''
    $TTL 86400

    @ IN SOA ns1.${domain}. admin.${domain}. (
      2026031801 ; serial
      3600       ; refresh
      900        ; retry
      604800     ; expire
      86400      ; minimum TTL
    )

    @   IN NS  ns1.${domain}.
    ns1 IN A   ${entrypoint}
    @   IN A   ${entrypoint}

    music   IN CNAME @
    images  IN CNAME @
    papers  IN CNAME @
    cinema  IN CNAME @
    torrent IN CNAME @
  '';

  makeView = name: let
    vpn = networks."${name}";
    isPrimary = { primary ? false, ... }: primary;
  in ''
    view "private-${name}" {
      match-clients { ${if isPrimary vpn then "127.0.0.0/8;" else ""} ${vpn.prefix}.0/24; };

      zone "${domain}" {
        type master;
        file "${makeZone "${vpn.prefix}.1"}";
        allow-query { ${vpn.prefix}.0/24; };
        allow-transfer { none; };
      };
    };
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
    ] ++ map
      (x: "${networks."${x}".prefix}.0/24")
      (lib.attrNames networks);

    extraConfig = lib.concatStringsSep "\n" (
      map (x: makeView x) (lib.attrNames networks);
    )
  };
}
