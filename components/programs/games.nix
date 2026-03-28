{lib, config, pkgs, ...}: {
  options.games.enable = lib.mkEnableOption "Games";

  config = lib.mkIf config.games.enable {
    hardware.steam-hardware.enable = true;

    #Steam
    programs = {
      gamemode.enable = true;
      steam.enable = true;
    };

    # Packages
    environment.systemPackages = with pkgs; [
      prismlauncher
      heroic
    ];
  };
}
