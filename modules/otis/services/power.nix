{config, customLibs, ...}:

let
  inherit (customLibs.otis.opts) mkBoolOption;

  cfg = config.otis.services.power;
in {
  options.otis.services.power.enable = mkBoolOption "Power manager" false;

  config = {
    services = {
      power-profiles-daemon.enable = false;
      tlp.enable = false;

      tuned = {
        inherit (cfg) enable;
        ppdSupport = true;
      };
    };
  };
}
