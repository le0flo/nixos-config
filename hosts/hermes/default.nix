{config, inputs, pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./secrets.nix
  ];

  otis = {
    gui = {
      enable = true;
      niri.enable = true;
      windowmaker.enable = true;
    };

    net.vpn = {
      enable = true;
      role = "client";

      networks."home" = {
        privateKeyFile = "${config.age.secretsDir}/wireguard/home";
        publicKey = builtins.readFile "${inputs.nixos-secrets}/wireguard/afrodite-home.pub";
        port = 51820;
        subnet = "10.69.0.0/24";
        id = "101";
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

      isNormalUser = true;
    };
  };

  networking = {
    firewall.trustedInterfaces = [ "home" ];

    wireless.iwd = {
      enable = true;

      settings = {
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
        };

        Network.NameResolvingService = "resolvconf";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    iwgtk
    vesktop
    opencode
    openfortivpn
    freetds
    kubelogin
    azure-cli
    gh
  ];

  nixpkgs.config.allowUnfree = true;
}
