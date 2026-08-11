{config, lib, ...}:

let
  inherit (lib) mkEnableOption;

  audio = config.otis.services.audio;
in {
  options.otis.services.audio.enable = mkEnableOption "Audio stack";

  config = {
    services.pipewire = {
      inherit (audio) enable;
      
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
