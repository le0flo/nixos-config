{config, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatStringsSep
    head;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    splitString
    types;
in {
  options.otis.net.dns =
    let
      mkStrOption = description: default: mkOption {
        inherit description default;

        type = types.str;
      };

      mkStrListOption = description: default: mkOption {
        inherit description default;

        type = types.listOf types.str;
      };
    in {
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

  config =
    let
      net = config.otis.net;

      domain = net.dns.domains.private;
      subdomains = net.dns.subdomains.private;
      server = net.dns.server;
      vpn = net.vpn;

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
    in mkIf (server.enable && vpn.role == "server") {
      networking.firewall.allowedUDPPorts = [ 53 ];

      services.bind = {
        inherit (server) forwarders;

        enable = true;
        forward = "only";

        cacheNetworks = [
          "127.0.0.0/8"
        ]
        ++ map (x: vpn.networks."${x}".subnet) (attrNames vpn.networks);

        extraConfig = concatStringsSep "\n" (map
          (x: let
            net = vpn.networks."${x}";
          in ''
            view "private-${x}" {
              match-clients { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };

              zone "${domain}" {
                type master;
                file "${makeZone (head (splitString "/" net.subnet))}";
                allow-query { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };
                allow-transfer { none; };
              };
            };
          '')
          (attrNames vpn.networks));
    };
  };
}
