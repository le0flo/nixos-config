{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.programs.games;
in {
  options.hostConfig.programs.games.enable = mkBoolOption "Games" false;

  config = mkIf (gui.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [
      minigalaxy
      prismlauncher
    ];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };
}
