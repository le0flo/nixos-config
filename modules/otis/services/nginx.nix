{config, lib, ...}:

let
  inherit (builtins)
    filter
    listToAttrs;

  inherit (lib)
    join
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.services.nginx =
    let
      site = {
        subdomain = mkOption {
          type = types.str;
          description = "The subdomain where this website is hosted on (use @ to reference the root domain)";
          default = null;
        };

        onlyPrimary = mkEnableOption "Only allow primary vpn devices to connect";

        type = mkOption {
          type = types.enum [ "files" "proxy" ];
          description = "Type of website";
        };

        root = mkOption {
          type = types.path;
          description = "The path for the root of the website";
          default = ./website;
        };

        autoindex = mkEnableOption "Whether to autoindex the root of the website";

        address = mkOption {
          type = types.str;
          description = "The address of the proxied website";
          default = "http://127.0.0.1:8080";
        };
      };
    in {
      enable = mkEnableOption "Nginx server";

      sites = {
        public = mkOption {
          type = types.listOf (types.submodule site);
          description = "List of public websites";
          default = [];
        };

        private = mkOption {
          type = types.listOf (types.submodule site);
          description = "List of private websites";
          default = [];
        };
      };
    };

  config =
    let
      nginx = config.otis.services.nginx;
      domains = config.otis.net.dns.domains;
      subdomains = config.otis.net.dns.subdomains;
      vpn = config.otis.net.vpn;

      mkVirtualHost = zone: sites: listToAttrs
        (map (x: {
          name = let
            domain = if zone == "public" then domains.public else domains.private;
          in if x.subdomain == "@" then domain else "${x.subdomain}.${domain}";
          value = mkMerge [
            (mkIf zone == "public" {
              useACMEHost = "${domain}";
              addSSL = true;
            })
            (mkIf zone == "private" {
              addSSL = false;
            })
            (mkIf x.type == "files" {
              inherit (x) root;

              extraConfig = if x.autoindex then ''
                autoindex on;
              '' else "";
            })
            (mkIf x.type == "proxy" {
              locations."/".proxyPass = x.address;
            })
            (mkIf x.onlyPrimary {
              extraConfig = if x.onlyPrimary then ''
                ${join "\n" (map (x: "allow ${x.subnet};") (filter (y: y.primary) vpn.networks))}
                deny all;
              '' else "";
            })
          ];
        }) sites);
    in {
      networking.firewall.allowedTCPPorts = mkIf nginx.enable [
        80
        443
      ];

      services.nginx = {
        inherit (nginx) enable;

        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = mkMerge [
          (mkVirtualHost "public" nginx.sites.public)
          (mkVirtualHost "private" nginx.sites.private)
        ];
      };
    };
}
