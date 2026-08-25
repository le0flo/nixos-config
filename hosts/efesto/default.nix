{config, inputs, pkgs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
  readKey = name: builtins.readFile "${secretsPath}/wireguard/${name}.pub";
in {
  imports = [
    ./hardware.nix
    ./secrets.nix
  ];

  otis = {
    net = {
      tls.custom.enable = true;

      vpn = {
        enable = true;
        role = "client";

        networks."home" = {
          privateKeyFile = "${config.age.secretsDir}/wireguard/home";
          publicKey = readKey "afrodite-external";
          port = 51821;
          subnet = "10.96.0.0/24";
          id = "4";
        };
      };
    };

    programs = {
      archive.enable = true;
      internet.enable = true;
    };

    services.openssh.enable = true;

    users."leo" = {
      groups = [ "wheel" ];

      ssh.authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKck97agpd7zRxRl2B40+5IK6wGCauT+u0M3QgRxLjxr leo@hermes"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKFIRcZxOfHi7XyMLUZMZEqRnY/RQpF0IT7wNqYtkOoa leo@zeus"
      ];
    };
  };

  # TODO: capire come far funzionare plasma-bigscreen
  environment.systemPackages = with pkgs; [ kdePackages.plasma-bigscreen ];
}
