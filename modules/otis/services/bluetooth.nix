{config, customLibs, ...}:

let
  inherit (customLibs.otis.opts) mkBoolOption;

  cfg = config.otis.services.bluetooth;
in {
  options.otis.services.bluetooth.enable = mkBoolOption "Bluetooth stack" false;

  config = {
    hardware.bluetooth = { inherit (cfg) enable; };
    services.blueman = { inherit (cfg) enable; };
  };
}
