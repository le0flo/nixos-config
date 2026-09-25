{config, inputs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;
in {
  imports = [ ./hardware.nix ];

  otis = {
    net.vpn = {
      enable = true;
      role = "client";

      networks."internal" = {
        primary = true;
        privateKeyFile = "${secretsDir}/wireguard/internal";
        publicKey = readPubKey "afrodite-internal";
        port = 51820;
        subnet = "10.69.0.0/16";
        id = "1.1";
      };
    };

    programs = {
      archive.enable = true;
      dev.enable = true;
      internet.enable = true;
      media.enable = true;
    };

    services = {
      k3s = {
        enable = true;
        role = "agent";
      };
      microvm = {
        enable = true;
        externalInterface = "eno1";
        vpnInterface = "internal";
        vms = [
          "sharing-02"
          "streaming-03"
        ];
      };
      openssh.enable = true;
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAokSVn78uTLEMp73AkLVA2q6+U+IPtqaeTc/HKGIFsV leo@hermes"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxFVKXr1GkMyIYDfjGvZhV8sbMM8PVMFWNj//jzFQAv leo@zeus"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWsnFie3ktqVVpKf5MFQPaOpLd+O21rWzdyFX0Lavhy leo@afrodite"
      ];
    };

    secrets = {
      "k3s/token" = {
        file = "${secretsEnc}/k3s/token.age";
        mode = "400";
      };

      "microvms/qbittorrent/password" = {
        file = "${secretsEnc}/microvms/qbittorrent.age";
        path = "/etc/qbittorrent/password";
        mode = "444";
        symlink = false;
      };

      "microvms/slskd/environment" = {
        file = "${secretsEnc}/microvms/slskd.age";
        path = "/etc/slskd/environment";
        mode = "444";
        symlink = false;
      };

      "wireguard/internal" = {
        file = "${secretsEnc}/wireguard/odino.age";
        mode = "400";
      };
    };
  };
}
