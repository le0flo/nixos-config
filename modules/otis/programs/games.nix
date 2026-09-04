{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.programs.games;
in {
  options.otis.programs.games.enable = mkBoolOption "Add games" false;

  config = mkIf (gui.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [ prismlauncher ];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };
}
