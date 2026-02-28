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

  programs.zsh.enable = true;

  environment.shellAliases = {
    l = "eza -lh";
    ll = "eza -lah";

    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#odino";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#odino";
    update-home = "home-manager switch --flake ~/nixos#odino";
  };

  # Version
  system.stateVersion = "25.05";
}
