{config, hostName, pkgs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns) domains;
in {
  imports = [ ./hardware.nix ];

  otis = {
    gui = {
      enable = true;
      plasma-bigscreen = {
        enable = true;
        extraPackages = [ pkgs.kdePackages.discover ];
      };
    };

    net = {
      dns.domains = {
        public = "leoflo.net";
        private = "home.arpa";
      };

      tls = {
        enable = true;
        role = "client";
      };

      vpn = {
        enable = true;
        role = "client";

        networks."external" = {
          primary = true;
          privateKeyFile = "${secretsDir}/wireguard/external";
          publicKey = readPubKey "entrypoint-01-external";
          address = domains.public;
          port = 51821;
          subnet = "10.96.0.0/16";
          id = "1.1";
        };
      };

      wait-online.enable = false;
      wifi.enable = true;
    };

    programs = {
      archive.enable = true;
      internet.enable = true;
    };

    services.openssh.enable = true;

    users."tv" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBx/mSCrgbajdcvcsF22Ufn/Qasxdufqj23AeVgivO8 leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINA4bJ/Z/xH6QTXQu4YqtkgBtYIX+5p2GI5w9O656ZUG leo@pc-02"
      ];
    };

    secrets."wireguard/external" = {
      file = "${secretsEnc}/wireguard/${hostName}.age";
      mode = "400";
    };
  };

  services.getty.autologinUser = "tv";

  programs.bash.loginShellInit = ''
  if [ "$(tty)" = "/dev/tty1" ]; then
    exec start-plasma-bigscreen
  fi
  '';
}
