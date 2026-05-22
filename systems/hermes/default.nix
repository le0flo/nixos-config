{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix
    ./users.nix

    ./gui.nix
    ./services.nix
    ./programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#hermes";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#hermes";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#hermes";
  };

  system.stateVersion = "26.05";
}
