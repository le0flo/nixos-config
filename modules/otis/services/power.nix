{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.power;
in {
  options.otis.services.power.enable = mkBoolOption "Power manager" false;

  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = false;
      tlp.enable = false;
      tuned = {
        enable = true;
        ppdSupport = true;
      };
    };
  };
}
