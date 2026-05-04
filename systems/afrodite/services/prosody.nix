{config, ...}: let
  domainName = "leoflo.me";
  sslCertDir = config.security.acme.certs.${domainName}.directory;
in {
  networking.firewall = {
    allowedTCPPorts = [
      # Prosody
      5222
      5269

      # Coturn
      3478
      5349
    ];
    allowedUDPPorts = [
      # Coturn
      3478
      5349
    ];
    allowedUDPPortRanges = [
      # Coturn
      {
        from = 49152;
        to = 65535;
      }
    ];
  };

  users.groups."secrets".members = [
    config.services.prosody.user
    "turnserver"
  ];

  services = {
    prosody = {
      enable = true;
      checkConfig = false;
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
        announce = true;
        private = false;
        proxy65 = false;
        register = false;
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

          local turn_secret_file = Lua.io.open("/etc/secrets/prosody-coturn", "r")
          if not turn_secret_file then
            error("Could not open TURN shared secret file")
          end

          turn_external_secret = turn_secret_file:read("*a"):gsub("%s+$", "")
          turn_secret_file:close()
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
      tls-listening-port = 5349;
      realm = "turn.xmpp.${domainName}";

      pkey = "${sslCertDir}/key.pem";
      cert = "${sslCertDir}/fullchain.pem";

      static-auth-secret-file = "/etc/secrets/prosody-coturn";
      use-auth-secret = true;
    };
  };
}
