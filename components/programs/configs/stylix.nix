{pkgs, ...}: {
  stylix = {
    enable = true;

    base16Scheme = {
      base00 = "#0b0e14";
      base01 = "#131721";
      base02 = "#202229";
      base03 = "#3e4b59";
      base04 = "#bfbdb6";
      base05 = "#e6e1cf";
      base06 = "#ece8db";
      base07 = "#f2f0e7";
      base08 = "#f07178";
      base09 = "#ff8f40";
      base0A = "#ffb454";
      base0B = "#aad94c";
      base0C = "#95e6cb";
      base0D = "#59c2ff";
      base0E = "#d2a6ff";
      base0F = "#e6b450";
    };

    polarity = "dark";

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
