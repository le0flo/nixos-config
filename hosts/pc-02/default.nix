{config, hostName, pkgs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns) domains;
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

        networks."internal" = {
          primary = true;
          privateKeyFile = "${secretsDir}/wireguard/internal";
          publicKey = readPubKey "entrypoint-01-internal";
          address = domains.public;
          port = 51820;
          subnet = "10.69.0.0/16";
          id = "2.2";
        };
      };

      wait-online.enable = true;
      wifi.enable = true;
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

    secrets."wireguard/internal" = {
      file = "${secretsEnc}/wireguard/${hostName}.age";
      mode = "400";
    };
  };
}
