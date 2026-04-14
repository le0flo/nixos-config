{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./services
    ./programs.nix
  ];

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Users
  users = {
    users."leo" = {
      isNormalUser = true;
      shell = pkgs.zsh;

      extraGroups = [
        "wheel"
        "networkmanager"
      ];

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAvs2K5ALiCxqylJ22zpMOXXGAaavoiXvZa1LuTq8Gx leo@hermes"
      ];
    };

    groups."git" = {};
  };

  # Shell
  programs.zsh.enable = true;

  environment.shellAliases = {
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#afrodite";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#afrodite";
    update-home = "home-manager switch --flake ~/nixos#afrodite";
  };

  # Version
  system.stateVersion = "26.05";
}
