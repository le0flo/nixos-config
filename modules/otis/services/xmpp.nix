{config, customLib, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.xmpp;
in {
  options.otis.services.xmpp = {
    enable = mkBoolOption "Prosody IM" false;
    domain = mkStrOption "The server's domain" "example.com";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
      5222
      5223
      5269
      5270
      5280
      5281
    ];

    services.prosody = {
      enable = true;
      admins = [ "amministrazione@${cfg.domain}" ];

      allowRegistration = false;
      authentication = "internal_hashed";
      c2sRequireEncryption = true;
      s2sSecureAuth = true;

      extraConfig = ''
      storage = "sql"
      sql = {
        driver = "SQLite3";
        database = "prosody.sqlite";
      }

      Component "upload.xmpp.${cfg.domain}"
        parent_host = "${cfg.domain}"
      '';

      httpFileShare = {
        domain = "upload.xmpp.${cfg.domain}";
        size_limit = 100 * 1024 * 1024;
      };

      modules = {
        admin_adhoc = true;
        admin_telnet = false;
        announce = false;
        blocklist = true;
        bookmarks = false;
        bosh = false;
        carbons = true;
        cloud_notify = true;
        dialback = true;
        disco = true;
        groups = false;
        http_files = true;
        legacyauth = false;
        limits = false;
        mam = true;
        motd = false;
        pep = true;
        ping = true;
        private = true;
        proxy65 = false;
        register = false;
        roster = false;
        saslauth = true;
        server_contact_info = false;
        smacks = true;
        time = true;
        tls = true;
        uptime = true;
        vcard = false;
        vcard_legacy = true;
        version = true;
        watchregistrations = false;
        websocket = false;
        welcome = false;
      };

      muc = [{
        domain = "muc.xmpp.${cfg.domain}";
        restrictRoomCreation = false;
      }];

      ssl = {
        cert = "${config.security.acme.certs."${cfg.domain}".directory}/fullchain.pem";
        key = "${config.security.acme.certs."${cfg.domain}".directory}/key.pem";
      };

      virtualHosts."main" = {
        enabled = true;
        domain = cfg.domain;
      };

      xmppComplianceSuite = false;
    };

    users.groups."public-acme".members = [ config.services.prosody.user ];
  };
}
