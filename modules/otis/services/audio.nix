{config, customLibs, ...}:

let
  inherit (customLibs.otis.opts) mkBoolOption;

  cfg = config.otis.services.audio;
in {
  options.otis.services.audio.enable = mkBoolOption "Audio stack" false;

  config = {
    services.pipewire = {
      inherit (cfg) enable;
      
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
