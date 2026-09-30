{config, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns) domains;
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

        server.enable = false;
      };

      tls = {
        enable = true;
        role = "server";

        publicAcme = {
          enable = true;
          email = "amministrazione@${domains.public}";
          certs = [{
            domain = "mx1.${domains.public}";
            subdomains = [];
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
        tls = config.security.acme.certs."mx1.${domains.public}".directory;
      };
      openssh.enable = true;
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoXUpu2q1UqJUn3IdWgesOPfqH6Vkkfwu5hV6NIKA7y leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzWR+C4+23sbaLfVT4k7BJ5nBGv+1lZ6OFg7IdH/icG leo@pc-02"
      ];
    };

    secrets."mail/dovecot-passwd" = {
      file = "${secretsEnc}/mail/dovecot-passwd.age";
      mode = "440";
      owner = "dovecot2";
      group = "dovecot2";
    };
  };
}
