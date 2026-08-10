{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;
in {
  options.otis.programs.media.enable = mkEnableOption "Add media related programs";

  config =
    let
      media = config.otis.programs.media;
      gui = config.otis.gui;
    in mkIf media.enable (mkMerge [
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
