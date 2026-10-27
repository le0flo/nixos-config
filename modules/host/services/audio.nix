{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkMerge
    mkIf;

  cfg = config.hostConfig.services.audio;
in {
  options.hostConfig.services.audio.enable = mkBoolOption "Audio stack" false;

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs.playerctl ];

      services.pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        easyeffects
        pavucontrol
      ];
    })
  ]);
}
