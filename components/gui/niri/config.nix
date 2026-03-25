{lib, config, ...}: {
  options.niri-config.enable = lib.mkEnableOption "Niri WM config";

  config = lib.mkIf config.niri-config.enable {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
