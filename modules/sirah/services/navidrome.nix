{config, customLib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  cfg = config.sirah.services.navidrome;
in {
  options.sirah.services.navidrome = {
    enable = mkBoolOption "Enable the Navidrome music server" false;
    port = mkPortOption "Port of the Navidrome server" 11001;
    musicDir = mkStrOption "Directory of the music libraries" "/media/music";
  };

  config = {
    services.navidrome = {
      inherit (cfg) enable;

      settings = {
        Address = "0.0.0.0";
        Port = cfg.port;
      };
    };

    systemd.services."navidrome".serviceConfig.BindReadOnlyPaths = [ cfg.musicDir ];
  };
}
