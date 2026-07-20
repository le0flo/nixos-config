{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./disk.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix
    ./users.nix

    ./services
    ./programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#host-afrodite";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#host-afrodite";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#host-afrodite";
  };

  system.stateVersion = "26.05";
}
