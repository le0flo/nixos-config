{config, customLib, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption;

  inherit (lib) mkIf;

  cfg = config.vmConfig.services.kanboard;
in {
  options.vmConfig.services.kanboard = {
    enable = mkBoolOption "Enable the Kanboard server" false;
    port = mkPortOption "Port of the Kanboard server" 13002;
  };

  config = mkIf cfg.enable {
    services.kanboard = {
      enable = true;
      domain = "kanboard";
      nginx = {
        serverName = "_";
        listen = [{ addr = "0.0.0.0"; port = cfg.port; }];
      };
    };
  };
}
