{lib, config, pkgs, ...}: {
  options.games.enable = lib.mkEnableOption "steam and other game launchers";

  config = lib.mkIf config.games.enable {
    hardware.steam-hardware.enable = true;

    #Steam
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };

    # Packages
    environment.systemPackages = with pkgs; [
      prismlauncher heroic

      gpu-screen-recorder gpu-screen-recorder-gtk
    ];
  };
}
