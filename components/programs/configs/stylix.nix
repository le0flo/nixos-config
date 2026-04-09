{pkgs, ...}: let
  wallpaper = ../../../assets/bg-sheeps.jpg;
in {
  dconf.enable = true;

  home.file.".config/stylix/wallpaper".source = wallpaper;

  xdg.dataFile = {
    "icons/Papirus-Dark".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    "icons/Papirus-Light".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Light";
    "icons/Papirus".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
    "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
  };

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

    polarity = "dark";

    image = wallpaper;

    icons = {
      enable = true;

      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 20;
    };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm NF";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
