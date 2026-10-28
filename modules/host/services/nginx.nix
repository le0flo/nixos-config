{config, customLib, lib, ...}:

let
  inherit (builtins)
    concatStringsSep
    length
    listToAttrs;

  inherit (config.hostConfig.net.dns) domains;

  inherit (config.hostConfig.net) vpn;

  inherit (config.hostConfig.services) fail2ban;

  inherit (customLib.net) subnetToPrefix;

  inherit (customLib.opts)
    mkAttrOption
    mkBoolOption
    mkEnumOption
    mkListOption
    mkListSubOption
    mkNullOption
    mkPortOption
    mkStrOption
    mkSubOption;

  inherit (lib)
    filter
    mkIf
    mkMerge
    types;

  cfg = config.hostConfig.services.nginx;

  siteOpts.options = {
    subdomain = mkStrOption "The subdomain where this website is hosted on (use @ to reference the root domain)" null;
    aliases = mkListOption types.str "Virtual host aliases" [];
    type = mkEnumOption [ "files" "proxy" ] "Type of website" null;
    root = mkStrOption "The path for the root of the website""/srv/www";
    autoindex = mkBoolOption "Whether to autoindex the root of the website" false;
    address = mkStrOption "The address of the proxied website" "http://127.0.0.1:8080";
    vpnInterfaces = mkListOption types.str "Allowed vpn interfaces" [];
  };

  tlsOpts.options = {
    type = mkEnumOption [ "none" "auto" "manual" ] "Type of tls handling" "none";
    cert = mkNullOption types.str "Path of the tls certificate" null;
    key = mkNullOption types.str "Path of the tls certificate's key" null;
  };

  streamOpts.options = {
    vpnInterfaces = mkListOption types.str "List of interfaces to forward the port to" [];
    proto = mkEnumOption [ "tcp" "udp" ] "The protocol of the forwarded port" "tcp";
    address = mkStrOption "The address to forward" "10.67.0.0";
    port = mkPortOption "The port to forward" 8080;
  };

  mkVirtualHost = zone: sites: listToAttrs
    (map (x: let
      domain = if zone == "public" then domains.public else domains.private;
      tls = cfg.tls."${zone}";
    in {
      name = if x.subdomain == "@" then domain else "${x.subdomain}.${domain}";
      value = mkMerge [
        {
          serverAliases = x.aliases;
          addSSL = tls.type != "none";
          useACMEHost = if (tls.type == "auto" && zone == "public") then "${domain}" else null;
          sslCertificate = if (tls.type == "auto" && zone == "private") then "/etc/ssl/certs/${domain}/cert.pem" else tls.cert;
          sslCertificateKey = if (tls.type == "auto" && zone == "private") then "/etc/ssl/certs/${domain}/private.key" else tls.key;
        }
        (mkIf (zone == "private") {
          extraConfig = ''
          client_max_body_size 50000M;
          '';
        })
        (mkIf (x.type == "files") {
          inherit (x) root;

          extraConfig = if x.autoindex then ''
          autoindex on;
          '' else "";
        })
        (mkIf (x.type == "proxy") {
          extraConfig = ''
          proxy_request_buffering off;
          '';

          locations."/".proxyPass = x.address;
        })
        (mkIf ((length x.vpnInterfaces) > 0) {
          extraConfig = ''
          ${concatStringsSep "\n" (map (x: "allow ${vpn.networks."${x}".subnet};") x.vpnInterfaces)}
          deny all;
          '';
        })
      ];
    }) sites);

  mkStreams = streams: concatStringsSep "\n" (map (x: ''
  ${concatStringsSep "\n" (map (y: let
    inherit (vpn.networks."${y}") id subnet;
  in ''
  server {
    listen ${subnetToPrefix subnet}.${id}:${toString x.port} ${if x.proto == "udp" then "udp" else ""};
    proxy_pass ${x.address}:${toString x.port};
  }
  '') x.vpnInterfaces)} '')streams);
in {
  options.hostConfig.services.nginx = {
    enable = mkBoolOption "Nginx server" false;

    sites = {
      public = mkListSubOption siteOpts "Public websites" [];
      private = mkListSubOption siteOpts "Private websites" [];
      extra = mkAttrOption "Other virtualhost definitions" {};
    };

    tls = {
      public = mkSubOption tlsOpts "TLS settings for public websites" {};
      private = mkSubOption tlsOpts "TLS settings for private websites" {};
    };

    streams = mkListSubOption streamOpts "Stream entries" [];
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ] ++ (map (x: x.port) (filter (x: x.proto == "tcp") cfg.streams));
      allowedUDPPorts = map (x: x.port) (filter (x: x.proto == "udp") cfg.streams);
    };

    services = {
      nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = mkMerge [
          (mkVirtualHost "public" cfg.sites.public)
          (mkVirtualHost "private" cfg.sites.private)
          cfg.sites.extra
        ];

        streamConfig = mkStreams cfg.streams;
      };

      fail2ban.jails = mkIf fail2ban.enable {
        "nginx-bad-request".settings = {
          enabled = true;
          action = ''iptables[type=multiport, port="80,443", protocol=tcp]'';
          filter = "nginx-bad-request";
          backend = "systemd";
        };
        "nginx-botsearch".settings = {
          enabled = true;
          action = ''iptables[type=multiport, port="80,443", protocol=tcp]'';
          filter = "nginx-botsearch";
          backend = "systemd";
        };
      };
    };

    users.groups = {
      "public-acme".members = [ config.services.nginx.user ];
      "private-acme".members = [ config.services.nginx.user ];
    };
  };
}
