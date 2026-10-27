{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.services.bluetooth;
in {
  options.hostConfig.services.bluetooth.enable = mkBoolOption "Bluetooth stack" false;

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
