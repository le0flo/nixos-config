{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  media = config.otis.programs.media;
  gui = config.otis.gui;
in {
  options.otis.programs.media.enable = mkEnableOption "Add media related programs";

  config = mkIf media.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        imagemagick
        ffmpeg
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        inkscape
        krita
        vlc
        strawberry
        kid3
      ];
    })
  ]);
}
