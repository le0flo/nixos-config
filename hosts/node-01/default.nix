{config, hostName, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.otis.net.dns) domains;
in {
  imports = [ ./hardware.nix ];

  otis = {
    net = {
      dns.domains = {
        public = "leoflo.net";
        private = "home.arpa";
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
      };
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1+ZhCdmiOz4tyIb6vueaxcQGKU+qnFx2FizHQLWg9H leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMswgwqMF9bq0ktTv7A1MMoNpyyhPKSbpAyGAEBPF1Qd leo@pc-02"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMXv96olyoS8JKmJtIcmDHlPaw9WuG6KGfhi3iKS1UH leo@entrypoint-01"
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
        file = "${secretsEnc}/wireguard/${hostName}.age";
        mode = "400";
      };
    };
  };
}
