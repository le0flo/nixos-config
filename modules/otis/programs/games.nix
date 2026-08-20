{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  games = config.otis.programs.media;
  gui = config.otis.gui;
in {
  options.otis.programs.games.enable = mkEnableOption "Add games";

  config = mkIf (gui.enable && games.enable) {
    environment.systemPackages = with pkgs; [
      prismlauncher
      lutris
    ];

    hardware.steam-hardware.enable = true;

    programs.steam = {
      enable = true;

      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
  };
}
