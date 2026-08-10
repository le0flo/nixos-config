{config, lib, ...}:

let
  inherit (lib) mkEnableOption;
in {
  options.otis.services.audio.enable = mkEnableOption "Audio stack";

  config =
    let
      audio = config.otis.services.audio;
    in {
      services.pipewire = {
        inherit (audio) enable;
        
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
