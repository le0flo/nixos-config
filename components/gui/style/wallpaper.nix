{pkgs, ...}:

let
  wallpaper = ../../../assets/bg-sheeps.png;
in {
  dconf.enable = true;

  home.file.".config/stylix/wallpaper".source = wallpaper;

  stylix.image = wallpaper;
}
