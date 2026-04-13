{pkgs, ...}: let
  wallpaper = ../../../assets/bg-cave.jpg;
in {
  dconf.enable = true;

  home.file.".config/stylix/wallpaper".source = wallpaper;
  stylix.image = wallpaper;
}
