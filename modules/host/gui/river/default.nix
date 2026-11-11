{config, customLib, inputs, lib, pkgs, ...}:

let
  inherit (customLib.hjem)
    configFmt
    configSource
    configSourceExe;
  
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.gui.river;
in {
  options.hostConfig.gui.river.enable = mkBoolOption "River wayland compositor" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases = {
        "start-kwm" = "~/.config/river/start kwm";
        "start-tarazed" = "~/.config/river/start tarazed";
      };
      systemPackages = with pkgs; [
        brightnessctl
        foot
        mako
        playerctl
        river
        river-wm.kwim
        river-wm.kwm
        river-wm.tarazed
        (scripts.override { withGui = true; })
        swaybg
        swayidle
        waylock
        wmenu
      ];
    };

    hostConfig.hjem = [{
      xdg.config.files = {
        "foot/foot.ini" = configFmt pkgs.formats.ini "foot.ini" {
          main = {
            term = "xterm-256color";
            pad = "5x5";
            font = "Iosevka NFM:size=16";
          };

          colors-dark.alpha = 0.7;
          colors-light.alpha = 0.7;
        };

        "kwim/config.zon" = configSource ./kwim.zon;
        "kwm/config.zon" = configSource ./kwm.zon;

        "mako/config" = configFmt pkgs.formats.iniWithGlobalSection "config" {
          globalSection = {
            actions = true;
            ignore-timeout = false;
            default-timeout = 10000;

            background-color = "#313131";
            text-color = "#efefef";
            border-color = "#ff0000";

            outer-margin = 0;
            margin = 0;
            border-size = 1;
          };
        };

        "river/init" = configSourceExe ./init.sh;
        "river/start" = configSourceExe ./start.sh;

        "systemd/user/river-session.target" = configFmt pkgs.formats.ini "river-session.target" {
          Unit = {
            Description = "River graphical session";
            BindsTo = "graphical-session.target";
            Wants = "graphical-session-pre.target";
            After = "graphical-session-pre.target";
          };
        };
      };
    }];

    security.pam.services."waylock".enable = true;

    xdg.portal = {
      config."river" = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];

      wlr = {
        enable = true;
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "dmenu";
            chooser_cmd = "${pkgs.wmenu}/bin/wmenu";
          };
        };
      };
    };
  };
}
