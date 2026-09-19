{config, customLib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  cfg = config.sirah.services.slskd;
in {
  options.sirah.services.slskd = {
    enable = mkBoolOption "Enable the slskd web client" false;
    port = mkPortOption "Port of the slskd server" 12002;
    envDir = mkStrOption "Environment file directory" "/etc/slskd";
    storageDir = mkStrOption "Directory of the slsk downloads" "/media/slsk";
  };

  config = {
    services.slskd = {
      inherit (cfg) enable;

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
