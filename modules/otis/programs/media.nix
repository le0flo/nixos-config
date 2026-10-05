{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.media;
in {
  options.otis.programs.media.enable = mkBoolOption "Media" false;

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        imagemagick
        ffmpeg
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        vlc
        strawberry
        ristretto
        inkscape
        krita
        kid3
      ];
    })
  ]);
}
