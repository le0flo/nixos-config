{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.sirah.services.immich;
in {
  options.sirah.services.immich = {
    enable = mkBoolOption "Enable the Immich photo and video server" false;
    port = mkPortOption "Port of the Immich server" 10002;
    mediaDir = mkStrOption "Directory of the photo storage" "/media/photos";
  };

  config = mkIf cfg.enable {
    services.immich = {
      inherit (cfg) port;

      enable = true;
      host = "0.0.0.0";

      machine-learning.enable = false;
      mediaLocation = cfg.mediaDir;
    };

    systemd.services."redis-immich".path = [ pkgs.coreutils ];
  };
}
