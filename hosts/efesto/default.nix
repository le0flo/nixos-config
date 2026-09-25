{config, customLib, inputs, pkgs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;
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
      tls.ca.enable = true;
      wait-online.enable = false;

      vpn = {
        enable = true;
        role = "client";

        networks."external" = {
          primary = true;
          privateKeyFile = "${secretsDir}/wireguard/external";
          publicKey = readPubKey "afrodite-external";
          port = 51821;
          subnet = "10.96.0.0/16";
          id = "1.1";
        };
      };
    };

    programs = {
      archive.enable = true;
      internet.enable = true;
    };

    services.openssh.enable = true;

    users."tv" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKck97agpd7zRxRl2B40+5IK6wGCauT+u0M3QgRxLjxr leo@hermes"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFIRcZxOfHi7XyMLUZMZEqRnY/RQpF0IT7wNqYtkOoa leo@zeus"
      ];
    };

    secrets."wireguard/external" = {
      file = "${secretsEnc}/wireguard/efesto.age";
      mode = "400";
    };
  };
}
