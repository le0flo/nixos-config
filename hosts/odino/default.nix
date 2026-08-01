{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./disk.nix
    ./hardware.nix
    ./secrets.nix
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
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#host-odino";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#host-odino";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#host-odino";
  };

  system.stateVersion = "26.05";
}
