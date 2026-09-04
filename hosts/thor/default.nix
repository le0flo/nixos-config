{config, inputs, lib, pkgs, self, ...}:

let
  inherit (builtins)
    concatStringsSep
    head;

  inherit (lib)
    dropEnd
    splitString;

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
        id = "3";
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
        externalInterface = "enp0s31f6";
        vms = [ "archive" ];
      };
      openssh.enable = true;
    };

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDG5j5kM8yANb6RGeFLGFJI8u62TBH01LgpN9jVmEALT leo@hermes"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUd1moOuOfUDSnljNzRHqs/HfFLSWz252h41MLm32Y7 leo@zeus"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVH95IieMMZ2R383n4+414Yu1T6NjmWYoUx1QsjTdOL leo@afrodite"
      ];
    };
  };

  system.activationScripts."paperless-environment" = {
    text = ''
    mkdir -p /etc/paperless
    cat > /etc/paperless/environment <<EOF
    PAPERLESS_URL=https://papers.${config.otis.net.dns.domains.private}
    PAPERLESS_TRUSTED_PROXIES=${concatStringsSep "." (dropEnd 1 (splitString "." (head (splitString "/" config.otis.net.vpn.networks."home".subnet))))}.1
    EOF
    '';
  };
}
