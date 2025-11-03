{lib, config, pkgs, ...}: {
  options.niri.enable = lib.mkEnableOption "niri wm";

  config = lib.mkIf config.niri.enable {
    programs = {
      niri.enable = true;
    };

    # Portals
    xdg.portal = {
      config."niri" = {
        default = [ "kde" "gtk" ];
      };

      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    };

    # Packages
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      fuzzel waybar
    ];
  };
}
