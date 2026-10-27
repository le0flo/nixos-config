{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.net.wifi;
in {
  options.hostConfig.net.wifi.enable = mkBoolOption "Enables the WiFi stack" false;

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
