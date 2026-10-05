{config, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns)
    domains
    subdomains;
in {
  imports = [ ./hardware.nix ];

  otis = {
    net = {
      ethernet = {
        static = true;
        address = "169.58.30.196/17";
        gateway = "169.58.0.1";
      };

      dns = {
        domains = {
          public = "leoflo.net";
          private = "home.arpa";
        };

        subdomains = {
          public = [
            "mx1"
            "xmpp"
            "muc.xmpp"
            "upload.xmpp"
            "proxy.xmpp"
            "mumble"
          ];
          private = [];
        };

        server.enable = false;
      };

      tls = {
        enable = true;

        publicAcme = {
          enable = true;
          email = "amministrazione@${domains.public}";
          certs = [{
            domain = domains.public;
            subdomains = subdomains.public;
            cfTokenFile = "${secretsDir}/dns/cloudflare";
          }];
        };
      };

      vpn.enable = false;
      wait-online.enable = true;
    };

    programs = {
      archive.enable = true;
      dev.enable = true;
      internet.enable = true;
    };

    services = {
      fail2ban.enable = true;
      mail = {
        enable = true;
        domain = domains.public;
        subdomain = "mx1";
        tls = config.security.acme.certs."${domains.public}".directory;
      };
      mumble = {
        enable = true;
        domain = domains.public;
        name = "Il server di leoflo";
        welcome = "<h1>Benvenuto</h1>";
        environmentFile = "${secretsDir}/mumble/environment";
      };
      openssh.enable = true;
      xmpp = {
        enable = true;
        domain = domains.public;
      };
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoXUpu2q1UqJUn3IdWgesOPfqH6Vkkfwu5hV6NIKA7y leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzWR+C4+23sbaLfVT4k7BJ5nBGv+1lZ6OFg7IdH/icG leo@pc-02"
      ];
    };

    secrets = {
      "dns/cloudflare" = {
        file = "${secretsEnc}/dns/cloudflare.age";
        mode = "400";
      };

      "mail/dovecot-passwd" = {
        file = "${secretsEnc}/mail/dovecot-passwd.age";
        mode = "440";
        owner = "dovecot2";
        group = "dovecot2";
      };

      "mumble/environment" = {
        file = "${secretsEnc}/mumble/environment.age";
        mode = "400";
      };
    };
  };
}
