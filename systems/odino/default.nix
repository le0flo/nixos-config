{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix
    ./users.nix

    ./services.nix
    ./programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#odino";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#odino";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#odino";
  };

  system.stateVersion = "26.05";
}
