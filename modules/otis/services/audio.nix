{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.audio;
in {
  options.otis.services.audio.enable = mkBoolOption "Audio stack" false;

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
