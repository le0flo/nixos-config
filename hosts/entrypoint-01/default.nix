{config, hostName, pkgs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns)
    domains
    subdomains;

  tmpfilesConfig = {
    mode = "0755";
    user = "leo";
    group = "users";
  };

  www-public = pkgs.www.public.override { domain = domains.public; };
  www-private = pkgs.www.private.override {
    privateDomain = domains.private;
    publicDomain = domains.public;
  };
in {
  imports = [ ./hardware.nix ];

  otis = {
    net = {
      dns = {
        domains = {
          public = "leoflo.net";
          private = "home.arpa";
        };

        subdomains = {
          public = [ "files" ];
          private = [
            "files"
            "music"
            "images"
            "papers"
            "cinema"
            "bt"
            "slsk"
          ];
        };

        server = {
          enable = true;
          forwarders = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      };

      tls = {
        enable = true;
        role = "server";

        publicAcme = {
          enable = true;
          email = "amministrazione@${domains.public}";
          certs = [{
            domain = domains.public;
            subdomains = subdomains.public;
          }];
        };

        privateAcme.enable = true;
      };

      vpn = {
        enable = true;
        role = "server";

        networks = {
          "internal" = {
            primary = true;
            privateKeyFile = "${secretsDir}/wireguard/internal";
            port = 51820;
            subnet = "10.69.0.0/16";
            id = "0.1";
            clients = [
              { publicKey = readPubKey "node-01"; id = "1.1"; }
              { publicKey = readPubKey "node-02"; id = "1.2"; }
              { publicKey = readPubKey "pc-01"; id = "2.1"; }
              { publicKey = readPubKey "pc-02"; id = "2.2"; }
              { publicKey = "vdQbZ0/xbQnGlyPRFEC4gugOXaVPyF6n0vHVAlyLFjU="; id = "3.1"; } # tel-01
            ];
          };

          "external" = {
            privateKeyFile = "${secretsDir}/wireguard/external";
            port = 51821;
            subnet = "10.96.0.0/16";
            id = "0.1";
            clients = [
              { publicKey = readPubKey "tv-01"; id = "1.1"; }
              { publicKey = "RD/w5EMw16BFWTbbsG2XIoXvPAxubDVmOjbzjWK2XF4="; id = "1.2"; } # tv-02
              { publicKey = "4o9ANbaAHabP1vJ2jaHLCePaFmELpyEX2ymkX6nJ/S0="; id = "2.1"; } # mybaby
            ];
          };
        };
      };

      wait-online.enable = true;
    };

    programs = {
      archive.enable = true;
      dev.enable = true;
      internet.enable = true;
    };

    services = {
      fail2ban.enable = true;
      k3s = {
        enable = true;
        role = "server";
      };
      nginx = {
        enable = true;

        sites = {
          public = [
            { subdomain = "@"; type = "files"; root = "${www-public}"; }
            { subdomain = "files"; type = "files"; root = "/srv/files/public"; autoindex = true; }
          ];
          private = [
            { subdomain = "@"; type = "files"; root = "${www-private}"; }
            { subdomain = "files"; type = "files"; root = "/srv/files/private"; autoindex = true; }
            { onlyPrimary = true; subdomain = "papers"; type = "proxy"; address = "http://10.69.1.2:10001"; }
            { onlyPrimary = true; subdomain = "images"; type = "proxy"; address = "http://10.69.1.2:10002"; }
            { subdomain = "music"; type = "proxy"; address = "http://10.69.1.1:11001"; }
            { subdomain = "cinema"; type = "proxy"; address = "http://10.69.1.1:11002"; }
            { onlyPrimary = true; subdomain = "bt"; type = "proxy"; address = "http://10.69.1.1:12001"; }
            { onlyPrimary = true; subdomain = "slsk"; type = "proxy"; address = "http://10.69.1.1:12002"; }
          ];
        };

        tls = {
          public.type = "auto";
          private.type = "auto";
        };
      };
      openssh.enable = true;
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWHB9ymzaRiCNoQVZQNaYJespbvwVslzG4+f5y4UqAh leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEU3PBMp+qLf00ymWz4acYTV2triftuIbU7GvKklvKmt leo@pc-02"
      ];
    };

    secrets = {
      "k3s/token" = {
        file = "${secretsEnc}/k3s/token.age";
        mode = "400";
      };

      "tls/ca.key" = {
        file = "${secretsEnc}/tls/ca.age";
        mode = "400";
      };

      "wireguard/external" = {
        file = "${secretsEnc}/wireguard/${hostName}-external.age";
        mode = "400";
      };

      "wireguard/internal" = {
        file = "${secretsEnc}/wireguard/${hostName}-internal.age";
        mode = "400";
      };
    };
  };

  systemd.tmpfiles.settings."nginx" = {
    "/srv/files/public".d = tmpfilesConfig;
    "/srv/files/private".d = tmpfilesConfig;
    "/srv/files/private/ca.pem".C = {
      age = "-";
      argument = "${secretsEnc}/tls/ca.pem";
    };
  };
}
