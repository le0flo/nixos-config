{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./locales.nix

    ./gui
    ./services
    ./programs
  ];

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Users
  users.users.leo = {
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [ "networkmanager" "video" "wheel" ];
  };

  # Version
  system.stateVersion = "25.05";
}
