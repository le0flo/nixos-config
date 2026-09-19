{config, inputs, pkgs, ...}:

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
    };

    net = {
      tls.ca.enable = true;
      wifi.enable = true;
      wait-online.enable = false;

      vpn = {
        enable = true;
        role = "client";

        networks."home" = {
          primary = true;
          privateKeyFile = "${config.age.secretsDir}/wireguard/home";
          publicKey = readKey "afrodite-home";
          port = 51820;
          subnet = "10.69.0.0/24";
          id = "101";
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
        externalInterface = "enp0s31f6";
      };
      power.enable = true;
      smartcards.enable = true;
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
      file = "${secretsPath}/wireguard/hermes.age";
      mode = "400";
    };
  };
}
