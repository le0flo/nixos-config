{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatStringsSep;

  inherit (config.otis.net) vpn;

  inherit (customLibs.otis.net) subnetToPrefix;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkListOption
    mkStrOption;

  inherit (lib)
    genAttrs
    mkIf
    types;

  cfg = config.otis.net.dns;

  makeZone = entrypoint: pkgs.writeText "${cfg.domains.private}-${entrypoint}" ''
  $TTL 86400

  @ IN SOA ns1.${cfg.domains.private}. admin.${cfg.domains.private}. (
    2026031801 ; serial
    3600       ; refresh
    900        ; retry
    604800     ; expire
    86400      ; minimum TTL
  )

  @   IN NS  ns1.${cfg.domains.private}.
  ns1 IN A   ${entrypoint}
  @   IN A   ${entrypoint}

  ${concatStringsSep "\n" (map (x: "${x} IN CNAME @") cfg.subdomains.private)}
  '';
in {
  options.otis.net.dns = {
    domains = {
      public = mkStrOption "Public facing domain" "example.com";
      private = mkStrOption "Private domain for internal communications" "example.com";
    };

    subdomains = {
      public = mkListOption types.str "List of public subdomains" [];
      private = mkListOption types.str "List of private subdomains" [];
    };

    server = {
      enable = mkBoolOption "Marks this host as the dns server" false;
      forwarders = mkListOption types.str "List of dns servers" [ "1.1.1.1" "1.0.0.1" ];
    };
  };

  config = mkIf (cfg.server.enable && vpn.role == "server") {
    networking.firewall.interfaces = genAttrs (attrNames vpn.networks) (name: { allowedUDPPorts = [ 53 ]; });

    services.bind = {
      inherit (cfg.server) forwarders;

      enable = true;
      forward = "only";

      cacheNetworks = [ "127.0.0.0/8" ] ++ map (x: vpn.networks."${x}".subnet) (attrNames vpn.networks);

      extraConfig = concatStringsSep "\n" (map (x: let
        net = vpn.networks."${x}";
      in ''
      view "private-${x}" {
        match-clients { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };

        zone "${cfg.domains.private}" {
          type master;
          file "${makeZone "${subnetToPrefix net.subnet}.${net.id}"}";
          allow-query { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };
          allow-transfer { none; };
        };
      };
      '') (attrNames vpn.networks));
    };
  };
}
