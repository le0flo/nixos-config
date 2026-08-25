{config, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatStringsSep
    head;

  inherit (lib)
    genAttrs
    last
    mkEnableOption
    mkIf
    mkOption
    splitString
    take
    toInt
    types;

  net = config.otis.net;
  domain = net.dns.domains.private;
  subdomains = net.dns.subdomains.private;
  server = net.dns.server;
  vpn = net.vpn;

  mkStrOption = description: default: mkOption {
    inherit description default;

    type = types.str;
  };

  mkStrListOption = description: default: mkOption {
    inherit description default;

    type = with types; listOf str;
  };

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

    ${concatStringsSep "\n" (map (x: "${x} IN CNAME @") subdomains)}
  '';

  mask = subnet: last (splitString "/" subnet);
  prefix = subnet: concatStringsSep "." (take
    ((toInt (mask subnet)) / 8)
    (splitString "." (head (splitString "/" subnet))));
in {
  options.otis.net.dns = {
    domains = {
      public = mkStrOption
        "Public facing domain for the otis network"
        "leoflo.net";

      private = mkStrOption
        "Private domain for internal communications between otis network devices"
        "home.arpa";
    };

    subdomains = {
      public = mkStrListOption
        "List of subdomains for the public domain"
        [ "files" ];

      private = mkStrListOption
        "List of subdomains for the private domain"
        [ "files" ];
    };

    server = {
      enable = mkEnableOption "Marks this host as the dns server";

      forwarders = mkStrListOption
        "List of dns servers that the local one uses to forward other requests"
        [
          "1.1.1.1"
          "1.0.0.1"
        ];
    };
  };

  config = mkIf (server.enable && vpn.role == "server") {
    networking.firewall.interfaces = genAttrs (attrNames vpn.networks) (name: { allowedUDPPorts = [ 53 ]; });

    services.bind = {
      inherit (server) forwarders;

      enable = true;
      forward = "only";

      cacheNetworks = [ "127.0.0.0/8" ] ++ map (x: vpn.networks."${x}".subnet) (attrNames vpn.networks);

      extraConfig = concatStringsSep "\n" (map
        (x: let
          net = vpn.networks."${x}";
        in ''
          view "private-${x}" {
            match-clients { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };

            zone "${domain}" {
              type master;
              file "${makeZone "${prefix net.subnet}.${net.id}"}";
              allow-query { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };
              allow-transfer { none; };
            };
          };
        '')
        (attrNames vpn.networks));
    };
  };
}
