{config, hostName, pkgs, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.hostConfig.net.dns) domains;
in {
  imports = [ ./hardware.nix ];

  nixpkgs.config.allowUnfree = true;

  hostConfig = {
    gui = {
      enable = true;
      hyprland.enable = true;
      windowmaker.enable = true;
    };

    net = {
      dns = {
        domains = {
          public = "leoflo.net";
          private = "home.arpa";
        };

        vpnInterface = "internal";
      };

      vpn = {
        enable = true;
        role = "client";

        networks."internal" = {
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

        database.enable = true;
        languages.enable = true;
        containers.enable = true;

        editors = {
          emacs = true;
          zed = true;
        };
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
      power.enable = true;
      virtualisation.enable = true;
    };

    users."leo" = {
      groups = [
        "audio"
        "dialout"
        "libvirtd"
        "video"
        "wheel"
      ];

      packages = with pkgs; [
        vesktop
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
