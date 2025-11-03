{lib, config, pkgs, ...}: {
  options.games.enable = lib.mkEnableOption "steam and other game launchers";

  config = lib.mkIf config.games.enable {
    hardware.steam-hardware.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
      prismlauncher heroic
    ];

    #Steam
    programs = {
      gamescope.enable = true;
      gamemode.enable = true;

      steam = {
        enable = true;
        gamescopeSession.enable = false; # SteamOS interface
      };
    };
  };
}
