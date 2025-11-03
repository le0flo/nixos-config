{inputs, pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./locales.nix

    ./gui
    ./services
    ./programs

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
    inputs.home-manager.nixosModules.home-manager
  ];

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Users
  users.users.leo = {
    isNormalUser = true;
    description = "Leonardo";
    shell = pkgs.zsh;

    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Version
  system.stateVersion = "25.05";
}
