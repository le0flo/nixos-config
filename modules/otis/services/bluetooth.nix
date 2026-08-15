{config, lib, ...}:

let
  inherit (lib) mkEnableOption;

  bluetooth = config.otis.services.bluetooth;
in {
  options.otis.services.bluetooth.enable = mkEnableOption "Bluetooth stack";

  config = {
    services.blueman.enable = bluetooth.enable;
  };
}
