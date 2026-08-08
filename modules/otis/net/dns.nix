{config, lib, pkgs, ...}:

{
  options.otis.net.dns =
    with lib;
    let
      t = types;

      mkStrOption = description: default: mkOption {
        inherit description default;

        type = t.str;
      };

      mkStrListOption = description: default: mkOption {
        inherit description default;

        type = t.listOf t.str;
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

      server = mkEnableOption "Bind dns server that provides a zone for the private domain and subdomains";
    };

  config = let
    domain = config.otis.net.dns.domains.private;
    subdomains = config.otis.net.dns.subdomains.private;

    server = config.otis.net.dns.server;
    vpn = config.otis.net.vpn;

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

      ${lib.concatStringsSep "\n" (map (x: "${x} IN CNAME @") subdomains)}
    '';
  in lib.mkIf server && vpn.role == "server"{
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
        (x: vpn.networks."${x}".subnet)
        (lib.attrNames vpn.networks);

      extraConfig = lib.concatStringsSep
        "\n"
        (map
          (x: let
            net = vpn.networks."${x}";
          in ''
            view "private-${x}" {
              match-clients { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };

              zone "${domain}" {
                type master;
                file "${makeZone (lib.head (lib.splitString "/" net.subnet))}";
                allow-query { ${if net.primary then "127.0.0.0/8;" else ""} ${net.subnet}; };
                allow-transfer { none; };
              };
            };
          '')
          (lib.attrNames vpn.networks));
    };
  };
}
