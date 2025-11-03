{lib, config, ...}: {
  options.waybar.enable = lib.mkEnableOption "waybar config";

  config = lib.mkIf config.waybar.enable {
  };
}
