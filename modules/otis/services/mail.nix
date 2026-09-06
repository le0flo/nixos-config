{config, customLibs, lib, ...}:

let
  inherit (customLibs.otis.opts)
    mkBoolOption
    mkEnumOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.mail;
in {
  options.otis.services.mail = {
    enable = mkBoolOption "Mail server" false;
    domain = mkStrOption "The domain name of the email" "example.com";
    subdomain = mkStrOption "The subdomain where the postfix server is hosted on" "mail";
    tls = mkEnumOption [ "acme" "manual" ] "Which tls certificates to use";
  };

  config = let
    sslCertDir = if cfg.tls == "acme" then config.security.acme.certs."${cfg.domain}".directory else "/etc/ssl";
  in mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      25
      465
      993
    ];

    services = {
      dovecot2 = {
        enable = true;
        enablePAM = false;
        createMailUser = true;

        settings = {
          dovecot_config_version = "2.4.4";
          dovecot_storage_version = "2.4.4";

          protocols = [ "imaps" "lmtp" ];

          ssl = "required";
          ssl_server_cert_file = "${sslCertDir}/fullchain.pem";
          ssl_server_key_file = "${sslCertDir}/key.pem";
          ssl_server_ca_file = "${sslCertDir}/chain.pem";

          auth_username_format = "%{user | lower}";
          auth_mechanisms = [ "plain" ];
          auth_verbose = true;

          "passdb passwd-file" = {
            passwd_file_path = config.age.secrets."mail/dovecot".path;

            driver = "passwd-file";
          };

          "userdb passwd-file" = {
            passwd_file_path = config.age.secrets."mail/dovecot".path;

            fields = {
              uid = "vmail";
              gid = "vmail";
              home = "/var/spool/mail/vmail/%{user | domain}/%{user | username}";
            };
          };

          "service auth" = {
            "unix_listener /var/spool/postfix/dovecot-auth" = {
              user = "postfix";
              group = "postfix";
              mode = "0600";
            };
          };

          "service lmtp" = {
            "unix_listener /var/spool/postfix/dovecot-lmtp" = {
              user = "postfix";
              group = "postfix";
              mode = "0600";
            };
          };

          mail_uid = "vmail";
          mail_gid = "vmail";
          mail_driver = "maildir";
          mail_path = "~/Maildir";

          "namespace inbox" = {
            "mailbox All" = { auto = "create"; special_use = "\\All"; };
            "mailbox Archive" = { auto = "create"; special_use = "\\Archive"; };
            "mailbox Drafts" = { auto = "create"; special_use = "\\Drafts"; };
            "mailbox Junk" = { auto = "create"; special_use = "\\Junk"; autoexpunge = "10d"; };
            "mailbox Sent" = { auto = "create"; special_use = "\\Sent"; };
            "mailbox Trash" = { auto = "create"; special_use = "\\Trash"; autoexpunge = "60d"; };
          };
        };
      };

      postfix = {
        enable = true;
        enableSubmissions = true;

        hostname = "${cfg.subdomain}.${cfg.domain}";
        domain = "${cfg.domain}";

        sslCert = "${sslCertDir}/fullchain.pem";
        sslKey = "${sslCertDir}/key.pem";

        config = {
          mailbox_transport = "lmtp:unix:/var/spool/postfix/dovecot-lmtp";
          virtual_transport = "lmtp:unix:/var/spool/postfix/dovecot-lmtp";
          virtual_mailbox_domains = "${cfg.domain}";

          smtpd_sasl_type = "dovecot";
          smtpd_sasl_path = "/var/spool/postfix/dovecot-auth";
          smtpd_sasl_auth_enable = "yes";
          smtpd_relay_restrictions = "permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination";
        };
      };
    };
  };

  systemd.tmpfiles.settings."mail" = {
    "/var/spool/mail/vmail".d = {
      mode = "0700";
      user = "vmail";
      group = "vmail";
    };
    "/var/spool/postfix".d = {
      mode = "0700";
      user = "postfix";
      group = "postfix";
    };
  };
}
