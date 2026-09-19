{config, inputs, lib, pkgs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
  readKey = name: builtins.readFile "${secretsPath}/wireguard/${name}.pub";
in {
  imports = [ ./hardware.nix ];

  nixpkgs.config.allowUnfree = true;

  otis = {
    gui = {
      enable = true;
      hyprland.enable = true;
      windowmaker.enable = true;
    };

    net = {
      tls.custom.enable = true;
      wifi.enable = true;

      vpn = {
        enable = true;
        role = "client";

        networks."home" = {
          primary = true;
          privateKeyFile = "${config.age.secretsDir}/wireguard/home";
          publicKey = readKey "afrodite-home";
          port = 51820;
          subnet = "10.69.0.0/24";
          id = "102";
        };
      };
    };

    programs = {
      archive.enable = true;
      dev = {
        enable = true;
        virt-manager = true;
      };
      devices.enable = true;
      fun.enable = true;
      games.enable = true;
      internet.enable = true;
      media.enable = true;
      office.enable = true;
    };

    services = {
      audio.enable = true;
      bluetooth.enable = true;
      docker.enable = true;
      microvm = {
        enable = true;
        externalInterface = "eth0";
      };
      power.enable = true;
    };

    users."leo" = {
      groups = [
        "audio"
        "dialout"
        "docker"
        "libvirtd"
        "video"
        "wheel"
      ];

      packages = with pkgs; [
        vesktop
        codex
        openfortivpn
        freetds
        kubelogin
        azure-cli
        gh
      ];
    };

    secrets."wireguard/home" = {
      file = "${secretsPath}/wireguard/zeus.age";
      mode = "400";
    };
  };
}
