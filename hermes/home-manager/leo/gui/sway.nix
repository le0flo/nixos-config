{lib, config, ...}: {
  options.sway.enable = lib.mkEnableOption "sway wm config";

  config = lib.mkIf config.sway.enable {
    wayland.windowManager.sway = {
      enable = true;

      systemd.enable = true;

      checkConfig = true;
      config = {
        modifier = "Mod4";

        terminal = "alacritty";
        menu = "wmenu-run";

        input = {
          "*" = {
            xkb_layout = "it";

            natural_scroll = "enabled";
          };
        };

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;

          terminal = config.wayland.windowManager.sway.config.terminal;
          menu = config.wayland.windowManager.sway.config.menu;
        in lib.mkOptionDefault {
          "${modifier}+Shift+c" = "kill";
          "${modifier}+Shift+q" = "exec swaymsg exit";
          "${modifier}+Shift+Return" = "exec ${terminal}";
          "${modifier}+p" = "exec ${menu}";

          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";
        };
      };
    };
  };
}
