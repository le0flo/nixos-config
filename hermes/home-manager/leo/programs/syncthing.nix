{lib, config, ...}: {
  options.syncthing.enable = lib.mkEnableOption "syncthing config";

  config = lib.mkIf config.syncthing.enable {
    services.syncthing.enable = true;
  };
}
