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

    # OBS
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      #plugins = with pkgs.obs-studio-plugins; [
      #  droidcam-obs
      #];
    };
  };
}
