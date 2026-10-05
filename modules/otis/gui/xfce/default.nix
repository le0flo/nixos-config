{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.hjem) configSource;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.gui.xfce;
in {
  options.otis.gui.xfce.enable = mkBoolOption "Xfce desktop environment" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-xfce4" = "startx ~/.config/xfce4/start.sh";
      systemPackages = [ pkgs.xfce4-whiskermenu-plugin ];
    };

    otis.hjem = [{
      xdg.config.files."xfce4/start.sh" = configSource ./start.sh;
    }];

    services.xserver.desktopManager.xfce.enable = true;

    xdg.portal = {
      config."xfce".default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
