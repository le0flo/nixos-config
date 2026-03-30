{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./gui.nix
    ./services.nix
    ./programs.nix
  ];

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Users
  users.users.leo = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
  };

  # Shell
  programs.zsh.enable = true;

  environment.shellAliases = {
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#hermes";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#hermes";
    update-home = "home-manager switch --flake ~/nixos#hermes";
  };

  # Version
  system.stateVersion = "25.05";
}
