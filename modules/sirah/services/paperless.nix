{config, customLib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPortOption
    mkStrOption;

  cfg = config.sirah.services.paperless;
in {
  options.sirah.services.paperless = {
    enable = mkBoolOption "Enable the Paperless-NGX document archive" false;
    port = mkPortOption "Port of the Paperless-NGX server" 10001;
    envDir = mkStrOption "Environment file directory" "/etc/paperless";
    exportDir = mkStrOption "Directory of the exporter" "/media/documents";
  };

  config = {
    services.paperless = {
      inherit (cfg) enable port;

      address = "0.0.0.0";

      environmentFile = "${cfg.envDir}/environment";

      exporter = {
        enable = true;
        directory = cfg.exportDir;
        onCalendar = "07:00:00";
        settings.zip = true;
      };
    };
  };
}
