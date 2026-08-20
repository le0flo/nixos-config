{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  wifi = config.otis.net.wifi;
  gui = config.otis.gui;
in {
  options.otis.net.wifi.enable = mkEnableOption "Toggles the wifi stack";

  config = mkIf wifi.enable {
    environment.systemPackages = with pkgs; [
      iw
      (mkIf gui.enable iwgtk)
    ];

    networking.wireless.iwd = {
      enable = true;

      settings = {
        DriverQuirks = {
          PowerSaveDisable = "*";
        };

        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
        };

        Network.NameResolvingService = "resolvconf";
      };
    };
  };
}
