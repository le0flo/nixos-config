{config, lib, ...}:

let
  inherit (lib) mkEnableOption;
in {
  options.otis.services.power.enable = mkEnableOption "Power manager";

  config =
    let
      power = config.otis.services.power;
    in {
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
