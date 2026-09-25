{config, customLib, inputs, lib, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net)
    dns
    vpn;

  inherit (customLib.net) subnetToGateway;
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
        id = "1.2";
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
        vpnInterface = "internal";
        vms = [ "archive-01" ];
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

    secrets = {
      "k3s/token" = {
        file = "${secretsEnc}/k3s/token.age";
        mode = "400";
      };

      "wireguard/internal" = {
        file = "${secretsEnc}/wireguard/thor.age";
        mode = "400";
      };
    };
  };

  system.activationScripts."paperless-environment" = {
    text = ''
    mkdir -p /etc/paperless
    cat > /etc/paperless/environment <<EOF
    PAPERLESS_URL=https://papers.${dns.domains.private}
    PAPERLESS_TRUSTED_PROXIES=${subnetToGateway vpn.networks."internal".subnet}
    EOF
    '';
  };
}
