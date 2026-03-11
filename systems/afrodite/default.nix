{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./locales.nix

    ./services.nix
    ./programs.nix
  ];

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Users
  users.users.leo = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Shell
  programs.zsh.enable = true;

  environment.shellAliases = {
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#afrodite";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#afrodite";
    update-home = "home-manager switch --flake ~/nixos#afrodite";
  };

  # Version
  system.stateVersion = "25.05";
}
