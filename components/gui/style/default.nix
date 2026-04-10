{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./themes.nix
    ./wallpaper.nix
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    polarity = "dark";
  };
}
