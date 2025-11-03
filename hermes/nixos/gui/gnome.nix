{lib, config, pkgs, ...}: {
  options.gnome.enable = lib.mkEnableOption "gnome";

  config = lib.mkIf config.gnome.enable {
    services.desktopManager.gnome.enable = true;

    # Portals
    xdg.portal = {
      config."gnome" = {
        default = [ "gnome" "gtk" ];
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
    };

    # Packages
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-software
    ];

    # Excluded packages
    environment.gnome.excludePackages = with pkgs; [
      gnome-connections
      gnome-contacts
      gnome-disk-utility
      gnome-music
      gnome-tour
      gnome-weather

      epiphany
      geary
      totem
      evince
      decibels
      seahorse
      simple-scan
    ];
  };
}
