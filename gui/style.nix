{pkgs, ...}:

rec {
  polarity = "dark";

  wallpaper = "road.png";

  colors = {
    border = "#adc178";
    background = "#3d3d3d";
    text = "#fefae0";
    primary = "#adc178";
    secondary = "#dde5b6";
  };

  cursor = {
    name = "Adwaita";
    size = 20;
  };

  gtk = {
    icons = "elementary-xfce-dark";
    iconsPackages = with pkgs; [
      adwaita-icon-theme
      elementary-xfce-icon-theme
    ];

    theme = "Adwaita";
    themePackages = with pkgs; [];
  };

  qt = {
    style = "Fusion";
    icons = "elementary-xfce-dark";
    colorScheme = "darker";
    dialogs = "default";
  };
}
