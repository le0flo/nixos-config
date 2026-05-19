{config, ...}:

let
  colors = config.lib.stylix.colors;
  cursor = config.stylix.cursor;
in {
  xdg.configFile = {
    "niri/colors.kdl".text = ''
      layout {
        border {
          active-color "${colors.base0D}"
          inactive-color "${colors.base02}"
          urgent-color "${colors.base08}"
        }
      }
    '';

    "niri/cursor.kdl".text = ''
      cursor {
        xcursor-theme "${cursor.name}"
        xcursor-size ${builtins.toString cursor.size}
      }
    '';
  };
}
