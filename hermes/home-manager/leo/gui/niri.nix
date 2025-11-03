{lib, config, ...}: {
  options.niri.enable = lib.mkEnableOption "niri config";

  config = lib.mkIf config.niri.enable {
    xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
  };
}
