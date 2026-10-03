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
      443
      5222
      5223
    ];

    services.prosody = {
      enable = true;
      admins = [ "amministrazione@${cfg.domain}" ];

      allowRegistration = false;
      authentication = "internal_hashed";
      c2sRequireEncryption = true;
      s2sSecureAuth = true;

      disco_items = [
        {
          description = "multi user chat";
          url = "muc.xmpp.${cfg.domain}";
        }
      ];

      extraConfig = ''
      storage = "sql"
      sql = {
        driver = "SQLite3";
        database = "prosody.sqlite";
      }
      '';

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
        http_files = false;
        legacyauth = false;
        limits = false;
        mam = true;
        motd = false;
        pep = true;
        ping = true;
        private = true;
        proxy65 = true;
        register = false;
        roster = false;
        saslauth = true;
        server_contact_info = false;
        smacks = true;
        time = true;
        tls = true;
        uptime = true;
        vcard = true;
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
        domain = cfg.domain;
        enabled = true;
      };

      xmppComplianceSuite = false;
    };
  };
}
