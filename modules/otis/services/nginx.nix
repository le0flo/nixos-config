{config, customLibs, lib, ...}:

let
  inherit (builtins)
    attrValues
    concatStringsSep
    filter
    listToAttrs;

  inherit (config.otis.net.dns)
    domains
    subdomains;

  inherit (config.otis.net) vpn;

  inherit (customLibs.otis.opts)
    mkAttrOption
    mkAttrSubOption
    mkBoolOption
    mkEnumOption
    mkListOption
    mkListSubOption
    mkNullOption
    mkStrOption
    mkSubOption;

  inherit (lib)
    mkIf
    mkMerge
    types;

  cfg = config.otis.services.nginx;

  siteOpts.options = {
    onlyPrimary = mkBoolOption "Only allow primary vpn devices to connect" false;
    subdomain = mkStrOption "The subdomain where this website is hosted on (use @ to reference the root domain)" null;
    type = mkEnumOption [ "files" "proxy" ] "Type of website" null;
    root = mkStrOption "The path for the root of the website""/srv/www";
    autoindex = mkBoolOption "Whether to autoindex the root of the website" false;
    address = mkStrOption "The address of the proxied website" "http://127.0.0.1:8080";
  };

  tlsOpts.options = {
    type = mkEnumOption [ "none" "acme" "manual" ] "Type of tls handling" "none";
    cert = mkNullOption types.str "Path of the tls certificate" null;
    key = mkNullOption types.str "Path of the tls certificate's key" null;
  };

  mkVirtualHost = zone: sites: listToAttrs
    (map (x: let
      domain = if zone == "public" then domains.public else domains.private;
      tls = cfg.tls."${zone}";
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
          ${concatStringsSep "\n" (map (x: "allow ${x.subnet};") (filter (y: y.primary) (attrValues vpn.networks)))}
          deny all;
          '' else "";
        })
      ];
    }) sites);
in {
  options.otis.services.nginx = {
    enable = mkBoolOption "Nginx server" false;

    sites = {
      public = mkListSubOption siteOpts "List of public websites" [];
      private = mkListSubOption siteOpts "List of private websites" [];
      extra = mkAttrOption "Other VirtualHost definitions" {};
    };

    tls = {
      public = mkSubOption tlsOpts "TLS settings for public websites" {};
      private = mkSubOption tlsOpts "TLS settings for private websites" {};
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = mkIf cfg.enable [
      80
      443
    ];

    services.nginx = {
      inherit (cfg) enable;

      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = mkMerge [
        (mkVirtualHost "public" cfg.sites.public)
        (mkVirtualHost "private" cfg.sites.private)
        cfg.sites.extra
        {
          "_" = {
            default = true;

            listen = [{
              addr = "0.0.0.0";
              port = 80;
            }];

            locations."/.well-known/acme-challenge/" = {
              root = "/var/lib/acme/acme-challenge";
            };

            locations."/" = {
              return = "404";
            };
          };
        }
      ];
    };
  };
}
