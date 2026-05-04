{config, ...}: let
  domainName = "leoflo.me";
  sslCertDir = config.security.acme.certs.${domainName}.directory;
in {
  networking.firewall = {
    allowedTCPPorts = [
      # Prosody
      5222
      5223

      # Coturn
      3478
      3479
      5349
      5350
    ];
    allowedUDPPorts = [
      # Coturn
      3478
      3479
      5349
      5350
    ];
    allowedUDPPortRanges = [
      # Coturn
      {
        from = 49152;
        to = 65535;
      }
    ];
  };

  age.secrets.prosody-coturn = {
    file = ./prosody-coturn.age;
    mode = "644";
  };

  services = {
    prosody = {
      enable = true;
      checkConfig = true;
      xmppComplianceSuite = false;

      c2sRequireEncryption = true;
      s2sSecureAuth = true;

      extraConfig = ''
        storage = "sql"
        sql = {
          driver = "SQLite3";
          database = "prosody.sqlite";
        }
      '';

      extraModules = [ "turn_external" ];
      modules = {
        admin_adhoc = true;
        admin_telnet = false;
        announce = true;
        blocklist = true;
        bookmarks = true;
        bosh = false;
        carbons = true;
        cloud_notify = true;
        csi = true;
        dialback = false;
        disco = true;
        groups = false;
        http_files = true;
        legacyauth = false;
        limits = false;
        mam = true;
        motd = false;
        pep = true;
        ping = true;
        private = false;
        proxy65 = false;
        register = false;
        roster = true;
        saslauth = true;
        server_contact_info = false;
        smacks = true;
        time = true;
        tls = true;
        uptime = true;
        vcard = true;
        vcard_legacy = false;
        version = true;
        watchregistrations = false;
        websocket = false;
        welcome = false;
      };

      ssl = {
        cert = "${sslCertDir}/fullchain.pem";
        key = "${sslCertDir}/key.pem";
      };

      allowRegistration = false;
      authentication = "internal_hashed";
      admins = [ "leoflo@${domainName}" ];

      disco_items = [
        {
          url = "muc.xmpp.${domainName}";
          description = "Multi-User Chat";
        }
        {
          url = "turn.xmpp.${domainName}";
          description = "STUN/TURN server";
        }
      ];

      virtualHosts."main" = {
        enabled = true;

        domain = "${domainName}";

        extraConfig = ''
          turn_external_host = "turn.xmpp.${domainName}"
          turn_external_secret = "${builtins.readFile config.age.secrets.prosody-coturn.path}"
        '';
      };

      muc = [
        {
          domain = "muc.xmpp.${domainName}";
          restrictRoomCreation = false;
        }
      ];
    };

    coturn = {
      enable = true;

      listening-port = 3478;
      realm = "turn.xmpp.${domainName}";

      pkey = "${sslCertDir}/key.pem";
      cert = "${sslCertDir}/fullchain.pem";

      static-auth-secret-file = config.age.secrets.prosody-coturn.path;
      use-auth-secret = true;
    };
  };
}
