{config, inputs, pkgs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
  readKey = name: builtins.readFile "${secretsPath}/wireguard/${name}.pub";
in {
  imports = [
    ./hardware.nix
    ./secrets.nix
  ];

  otis = {
    net.vpn = {
      enable = true;
      role = "client";

      networks."home" = {
        privateKeyFile = "${config.age.secretsDir}/wireguard/home";
        publicKey = readKey "afrodite-home";
        port = 51820;
        subnet = "10.69.0.0/24";
        id = "2";
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
        vms = [
          "navidrome"
          "jellyfin"
          "sharing"
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
  };
}
