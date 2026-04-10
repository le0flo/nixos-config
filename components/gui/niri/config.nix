{config, ...}: let
  colors = config.lib.stylix.colors;
in {
  xdg.configFile."niri/config.kdl".text = builtins.replaceStrings
    ["@active-color@" "@inactive-color@" "@urgent-color@"]
    ["#${colors.base0D}" "#${colors.base02}" "#${colors.base08}"]
    (builtins.readFile ./config.kdl);
}
