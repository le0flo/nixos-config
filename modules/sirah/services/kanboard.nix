{config, customLib, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.sirah.services.kanboard;
in {
  options.sirah.services.kanboard = {
    enable = mkBoolOption "Enable the Kanboard server" false;
    port = mkPortOption "Port of the Kanboard server" 13002;
    dataDir = mkStrOption "Data directory for the Kanboard service" "/media/tasks";
  };

  config = mkIf cfg.enable {
    services.kanboard = {
      inherit (cfg) dataDir;

      enable = true;
      domain = "kanboard";
      nginx = {
        serverName = "_";
        listen = [{ addr = "0.0.0.0"; port = cfg.port; }];
      };
    };
  };
}
