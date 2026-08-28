{config, lib, ...}:

let
  inherit (builtins)
    attrValues
    filter
    listToAttrs;

  inherit (lib)
    join
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  siteOpts.options = {
    onlyPrimary = mkEnableOption "Only allow primary vpn devices to connect";

    subdomain = mkOption {
      type = types.str;
      description = "The subdomain where this website is hosted on (use @ to reference the root domain)";
      default = null;
    };

    type = mkOption {
      type = types.enum [ "files" "proxy" ];
      description = "Type of website";
    };

    root = mkOption {
      type = types.str;
      description = "The path for the root of the website";
      default = "/srv/www";
    };

    autoindex = mkEnableOption "Whether to autoindex the root of the website";

    address = mkOption {
      type = types.str;
      description = "The address of the proxied website";
      default = "http://127.0.0.1:8080";
    };
  };

  tlsOpts.options = {
    type = mkOption {
      type = types.enum [ "none" "acme" "manual" ];
      description = "Type of tls handling";
      default = "none";
    };
    
    cert = mkOption {
      type = with types; nullOr str;
      description = "Path of the tls certificate";
      default = null;
    };

    key = mkOption {
      type = with types; nullOr str;
      description = "Path of the tls certificate's key";
      default = null;
    };
  };

  nginx = config.otis.services.nginx;
  domains = config.otis.net.dns.domains;
  subdomains = config.otis.net.dns.subdomains;
  vpn = config.otis.net.vpn;

  mkVirtualHost = zone: sites: listToAttrs
    (map (x: let
      domain = if zone == "public" then domains.public else domains.private;
      tls = nginx.tls."${zone}";
    in {
      name = if x.subdomain == "@" then domain else "${x.subdomain}.${domain}";
      value = mkMerge [
        {
          addSSL = tls.type != "none";
          useACMEHost = if tls.type == "acme" then "${domain}" else null;
          sslCertificate = tls.cert;
          sslCertificateKey = tls.key;
        }
        (mkIf (x.type == "files") {
          inherit (x) root;

          extraConfig = if x.autoindex then ''
            autoindex on;
          '' else "";
        })
        (mkIf (x.type == "proxy") {
          locations."/".proxyPass = x.address;
        })
        (mkIf x.onlyPrimary {
          extraConfig = if x.onlyPrimary then ''
            ${join "\n" (map (x: "allow ${x.subnet};") (filter (y: y.primary) (attrValues vpn.networks)))}
            deny all;
          '' else "";
        })
      ];
    }) sites);
in {
  options.otis.services.nginx = {
    enable = mkEnableOption "Nginx server";

    sites = {
      public = mkOption {
        type = with types; listOf (submodule siteOpts);
        description = "List of public websites";
        default = [];
      };

      private = mkOption {
        type = with types; listOf (submodule siteOpts);
        description = "List of private websites";
        default = [];
      };

      extra = mkOption {
        type = types.attrs;
        description = "Other virtual hosts definitions";
        default = {};
      };
    };

    tls = {
      public = mkOption {
        type = types.submodule tlsOpts;
        description = "";
        default = {};
      };

      private = mkOption {
        type = types.submodule tlsOpts;
        description = "List of private websites";
        default = {};
      };
    };
  };

  config = {
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
        nginx.sites.extra
      ];
    };
  };
}
