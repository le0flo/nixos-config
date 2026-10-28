{config, hostName, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.hostConfig.net.dns) domains;
in {
  imports = [ ./hardware.nix ];

  hostConfig = {
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
          id = "1.1";
        };
      };

      wait-online.enable = true;
    };

    programs = {
      archive.enable = true;
      dev.enable = true;
      internet.enable = true;
      media.enable = true;
    };

    services = {
      hydra = {
        enable = true;
        role = "builder";
        vpnInterface = "internal";
      };
      nginx = {
        enable = true;

        streams = [
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.3"; port = 11001; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.3"; port = 11002; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.2"; port = 12001; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.2"; port = 12002; }
        ];
      };
      openssh.enable = true;
      virtualisation.enable = true;
    };

    users."leo" = {
      groups = [
        "libvirtd"
        "wheel"
      ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1+ZhCdmiOz4tyIb6vueaxcQGKU+qnFx2FizHQLWg9H leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMswgwqMF9bq0ktTv7A1MMoNpyyhPKSbpAyGAEBPF1Qd leo@pc-02"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMXv96olyoS8JKmJtIcmDHlPaw9WuG6KGfhi3iKS1UH leo@entrypoint-01"
      ];
    };

    secrets = {
      "hydra/token" = {
        file = "${secretsEnc}/hydra/token.age";
        mode = "400";
        owner = "hydra-builder";
        group = "hydra";
      };

      "wireguard/internal" = {
        file = "${secretsEnc}/wireguard/${hostName}.age";
        mode = "400";
      };
    };
  };
}
