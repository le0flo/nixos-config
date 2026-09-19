{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    filter
    concatStringsSep;

  inherit (config.otis.net) vpn;

  inherit (customLib.net)
    subnetToGateway
    subnetToPrefix;

  inherit (customLib.opts)
    mkBoolOption
    mkListOption
    mkStrOption;

  inherit (lib)
    filterAttrs
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
      public = mkStrOption "Public facing domain" "leoflo.net";
      private = mkStrOption "Private domain for internal communications" "home.arpa";
    };

    subdomains = {
      public = mkListOption types.str "List of public subdomains" [];
      private = mkListOption types.str "List of private subdomains" [];
    };

    nameservers = mkListOption types.str "List of dns servers" [ "1.1.1.1" "1.0.0.1" ];

    server = {
      enable = mkBoolOption "Marks this host as the dns server" false;
      forwarders = mkListOption types.str "List of dns servers" [ "1.1.1.1" "1.0.0.1" ];
    };
  };

  config = {
    networking = {
      inherit (cfg) nameservers;

      firewall = mkIf (cfg.server.enable) {
        interfaces = genAttrs (attrNames vpn.networks) (name: { allowedUDPPorts = [ 53 ]; });
      };
    };

    services = {
      bind = {
        inherit (cfg.server) enable forwarders;

        listenOn = map (x: "${subnetToPrefix x.subnet}.${x.id}") (attrValues vpn.networks);
        listenOnIpv6 = [];
        forward = "only";

        cacheNetworks = map (x: vpn.networks."${x}".subnet) (attrNames vpn.networks);

        extraConfig = concatStringsSep "\n" (map (x: let
          net = vpn.networks."${x}";
        in ''
        view "private-${x}" {
          match-clients { ${net.subnet}; };

          zone "${cfg.domains.private}" {
            type master;
            file "${makeZone "${subnetToPrefix net.subnet}.${net.id}"}";
            allow-query { ${net.subnet}; };
            allow-transfer { none; };
          };
        };
        '') (attrNames vpn.networks));
      };

      resolved.enable = true;
    };

    systemd.network.networks."30-vpn" = {
      matchConfig.Name =  concatStringsSep "," (attrNames (filterAttrs (_: y: y.primary) vpn.networks));

      dns = map (x: subnetToGateway x.subnet) (filter (y: y.primary) (attrValues vpn.networks));
      domains = [ "~${cfg.domains.private}" ];
    };
  };
}
