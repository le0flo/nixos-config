{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.programs.media;
in {
  options.hostConfig.programs.media.enable = mkBoolOption "Media" false;

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        imagemagick
        ffmpeg
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        imv
        strawberry
        mpv-unwrapped
        krita
        inkscape
        kid3
      ];
    })
  ]);
}
