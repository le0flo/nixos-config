{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.net.wifi;
in {
  options.otis.net.wifi.enable = mkBoolOption "Toggles the wifi stack" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iw
      (mkIf gui.enable iwgtk)
    ];

    networking.wireless.iwd = {
      enable = true;

      settings = {
        DriverQuirks.PowerSaveDisable = "*";

        General = {
          EnableNetworkConfiguration = false;
          AddressRandomization = "network";
        };

        Network.NameResolvingService = "systemd";
      };
    };
  };
}
