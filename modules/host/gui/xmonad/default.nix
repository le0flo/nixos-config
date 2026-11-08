{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.hjem) configSource;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.gui.xmonad;
in {
  options.hostConfig.gui.xmonad.enable = mkBoolOption "XMonad window manager" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-xmonad" = "startx ~/.config/xmonad/start.sh";
      systemPackages = with pkgs; [
        dmenu
        rxvt-unicode
        xmobar
        xwallpaper
      ];
    };

    hostConfig.hjem = [{
      files.".xmobarrc" = configSource ./xmobarrc;

      xdg.config.files = {
        "xmonad/start.sh" = configSource ./start.sh;
        "xmonad/xmonad.hs" = configSource ./xmonad.hs;
      };
    }];

    programs.slock.enable = true;

    security.pam.services."slock".enable = true;

    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    xdg.portal = {
      config."xmonad".default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
