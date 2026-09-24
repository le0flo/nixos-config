{config, customLib, pkgs, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  cfg = config.sirah.services.immich;
in {
  options.sirah.services.immich = {
    enable = mkBoolOption "Enable the Immich photo and video server" false;
    port = mkPortOption "Port of the Immich server" 10002;
    mediaDir = mkStrOption "Directory of the photo storage" "/media/photos";
  };

  config = {
    services.immich = {
      inherit (cfg) enable port;

      host = "0.0.0.0";

      machine-learning.enable = false;
      mediaLocation = cfg.mediaDir;
    };

    systemd.services."redis-immich".path = [ pkgs.coreutils ];
  };
}
