{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.services.power;
in {
  options.hostConfig.services.power.enable = mkBoolOption "Power manager" false;

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
