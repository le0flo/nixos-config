{pkgs, ...}:

rec {
  polarity = "dark";

  wallpaper = ../assets/bg-valley.png;

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

  fonts = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    nerd-fonts.comic-shanns-mono
    nerd-fonts.iosevka
  ];

  gtk = {
    icons = "elementary-xfce";
    iconsPackages = with pkgs; [
      adwaita-icon-theme
      elementary-xfce-icon-theme
    ];

    theme = "Adwaita";
    themePackages = with pkgs; [];
  };

  qt = {
    colorScheme = if polarity == "dark" then "BreezeDark" else "BreezeLight";
    colorSchemeFile = "${qt.stylePackage}/share/color-schemes/${qt.colorScheme}.colors";

    stylePackage = pkgs.kdePackages.breeze;
    style = "Breeze";

    iconsPackage = pkgs.kdePackages.breeze-icons;
    icons = "breeze-dark";

    extraPackages = with pkgs.kdePackages; [
      plasma-integration
      qqc2-breeze-style
    ];
  };

  packages = fonts
    ++ gtk.iconsPackages
    ++ gtk.themePackages
    ++ [
      qt.stylePackage
      qt.iconsPackage
    ]
    ++ qt.extraPackages;
}
