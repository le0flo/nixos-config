{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.media;
in {
  options.otis.programs.media.enable = mkBoolOption "Add media related programs" false;

  config = mkIf cfg.enable (mkMerge [
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
