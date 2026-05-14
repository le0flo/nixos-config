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
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "dialout"
      "wheel"
      "video"
    ];
  };

  # Shell
  environment.shellAliases = {
    update-build = "sudo nixos-rebuild build --flake ~/nixos#hermes";
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#hermes";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#hermes";
    update-home = "home-manager switch --flake ~/nixos#hermes";
  };

  # Version
  system.stateVersion = "26.05";
}
