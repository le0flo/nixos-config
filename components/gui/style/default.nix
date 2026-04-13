{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./themes.nix
    ./wallpaper.nix
  ];

  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruber.yaml";
    polarity = "dark";
  };
}
