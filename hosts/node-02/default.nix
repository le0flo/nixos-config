{config, hostName, readPubKey, secretsEnc, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.hostConfig.net) dns;
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
          address = dns.domains.public;
          port = 51820;
          subnet = "10.69.0.0/16";
          id = "1.2";
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
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.1"; port = 10001; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.1"; port = 10002; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.4"; port = 13001; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.4"; port = 13002; }
          { vpnInterfaces = [ "internal" ]; proto = "tcp"; address = "10.67.1.4"; port = 13022; }
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkMMcdlECZOLCVONmP9/EOFrorigaCo2r2xuc40MtpS leo@pc-01"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKlsuOiACmoMbxggrDqhEq/oPiNFG0bcJRqp8fg6Niz leo@pc-02"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDc8Ehaf4i71hebfXacTCxrOnYrqrNdpyrPz2RkRyZ70 leo@entrypoint-01"
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
