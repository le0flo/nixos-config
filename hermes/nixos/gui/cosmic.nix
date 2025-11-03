{lib, config, pkgs, ...}: {
  options.cosmic.enable = lib.mkEnableOption "cosmic";

  config = lib.mkIf config.cosmic.enable {
    services.desktopManager.cosmic.enable = true;

    # Portals
    xdg.portal = {
      config."cosmic" = {
        default = [ "cosmic" ];
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
      ];
    };
  };
}
