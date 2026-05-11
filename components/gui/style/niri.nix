{config, ...}: {
  xdg.configFile = {
    "niri/colors.kdl".text = ''
    layout {
      border {
        active-color "${config.lib.stylix.colors.base0D}"
        inactive-color "${config.lib.stylix.colors.base02}"
        urgent-color "${config.lib.stylix.colors.base08}"
      }
    }
    '';

    "niri/cursor.kdl".text = ''
    cursor {
      xcursor-theme "${config.stylix.cursor.name}"
      xcursor-size ${builtins.toString config.stylix.cursor.size}
    }
    '';
  };
}
