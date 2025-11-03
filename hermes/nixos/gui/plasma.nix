{lib, config, pkgs, ...}: {
  options.plasma.enable = lib.mkEnableOption "kde plasma";

  config = lib.mkIf config.plasma.enable {
    services.desktopManager.plasma6.enable = true;

    # Portals
    xdg.portal = {
      config.kde = {
        default = [ "kde" "gtk" ];
      };

      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    };

    # Packages
    environment.systemPackages = with pkgs.kdePackages; [
      kate
      filelight
      discover

      flatpak-kcm
    ];

    # Excluded packages
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      elisa
    ];
  };
}
