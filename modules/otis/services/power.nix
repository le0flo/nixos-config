{config, lib, ...}:

let
  inherit (lib) mkEnableOption;

  power = config.otis.services.power;
in {
  options.otis.services.power.enable = mkEnableOption "Power manager";

  config = {
    services = {
      power-profiles-daemon.enable = false;
      tlp.enable = false;

      tuned = {
        enable = power.enable;
        ppdSupport = true;
      };
    };
  };
}
