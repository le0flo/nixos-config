{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./gui.nix
    ./services.nix
    ./programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users."leo" = {
    isNormalUser = true;
    extraGroups = [
      "dialout"
      "docker"
      "libvirtd"
      "video"
      "wheel"
    ];

    shell = pkgs.bash;
  };

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#hermes";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#hermes";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#hermes";
    "home-update" = "home-manager switch --flake ~/nixos#hermes";
  };

  system.stateVersion = "26.05";
}
