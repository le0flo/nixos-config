{config, customLib, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.sirah.services.slskd;
in {
  options.sirah.services.slskd = {
    enable = mkBoolOption "Enable the slskd web client" false;
    port = mkPortOption "Port of the slskd server" 12002;
    envDir = mkStrOption "Environment file directory" "/etc/slskd";
    storageDir = mkStrOption "Directory of the slsk downloads" "/media/slsk";
  };

  config = mkIf cfg.enable {
    services.slskd = {
      enable = true;
      openFirewall = true;

      environmentFile = "${cfg.envDir}/environment";

      settings = {
        directories = {
          downloads = "${cfg.storageDir}/complete";
          incomplete = "${cfg.storageDir}/incomplete";
        };
        web = { inherit (cfg) port; };
      };
    };
  };
}
