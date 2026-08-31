{config, inputs, pkgs, ...}:

let
  inherit (config.otis.net.dns) domains;

  secretsPath = toString inputs.nixos-secrets;
  www-public = pkgs.www.public.override { domain = domains.public; };
  www-private = pkgs.www.private.override { domain = domains.private; };
  tmpfilesConfig = {
    mode = "0755";
    user = "leo";
    group = "users";
  };

  readKey = name: builtins.readFile "${secretsPath}/wireguard/${name}.pub";
in {
  imports = [
    ./hardware.nix
    ./secrets.nix
  ];

  otis = {
    net = {
      dns = {
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

        server.enable = true;
      };

      tls.server.enable = true;

      vpn = {
        enable = true;
        role = "server";

        networks = {
          "home" = {
            primary = true;
            privateKeyFile = "${config.age.secretsDir}/wireguard/home";
            port = 51820;
            subnet = "10.69.0.0/24";
            id = "1";
            clients = [
              { publicKey = readKey "odino"; id = "2"; }
              { publicKey = readKey "thor"; id = "3"; }
              { publicKey = readKey "hermes"; id = "101"; }
              { publicKey = readKey "zeus"; id = "102"; }
              { publicKey = "vdQbZ0/xbQnGlyPRFEC4gugOXaVPyF6n0vHVAlyLFjU="; id = "103"; } # ares
            ];
          };

          "external" = {
            privateKeyFile = "${config.age.secretsDir}/wireguard/external";
            port = 51821;
            subnet = "10.96.0.0/24";
            id = "1";
            clients = [
              { publicKey = "RD/w5EMw16BFWTbbsG2XIoXvPAxubDVmOjbzjWK2XF4="; id = "2"; } # firetv
              { publicKey = "4o9ANbaAHabP1vJ2jaHLCePaFmELpyEX2ymkX6nJ/S0="; id = "3"; } # mybaby
              { publicKey = readKey "efesto"; id = "4"; }
            ];
          };
        };
      };
    };

    programs = {
      archive.enable = true;
      dev.enable = true;
      internet.enable = true;
    };

    services = {
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
            { onlyPrimary = true; subdomain = "papers"; type = "proxy"; address = "http://10.69.0.3:10001"; }
            { onlyPrimary = true; subdomain = "images"; type = "proxy"; address = "http://10.69.0.3:10002"; }
            { subdomain = "music"; type = "proxy"; address = "http://10.69.0.2:11001"; }
            { subdomain = "cinema"; type = "proxy"; address = "http://10.69.0.2:11002"; }
            { onlyPrimary = true; subdomain = "bt"; type = "proxy"; address = "http://10.69.0.2:12001"; }
            { onlyPrimary = true; subdomain = "slsk"; type = "proxy"; address = "http://10.69.0.2:12002"; }
          ];
        };

        tls = {
          public.type = "acme";
          private = {
            type = "manual";
            cert = "${secretsPath}/tls/${domains.private}.pem";
            key = "${config.age.secretsDir}/tls/${domains.private}.key";
          };
        };
      };
      openssh.enable = true;
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAvs2K5ALiCxqylJ22zpMOXXGAaavoiXvZa1LuTq8Gx leo@hermes"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmIanMLV3pgQFhe9V6Pb8483u+CuPwZF3vZ7Kt+Eyje leo@zeus"
      ];
    };
  };

  systemd.tmpfiles.settings."nginx" = {
    "/srv/files/public".d = tmpfilesConfig;
    "/srv/files/private".d = tmpfilesConfig;
    "/srv/files/private/ca.pem".C = {
      age = "-";
      argument = "${secretsPath}/tls/ca.pem";
    };
  };
}
