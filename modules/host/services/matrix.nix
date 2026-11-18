{config, customLib, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.services.matrix;
in {
  options.hostConfig.services.matrix = {
    enable = mkBoolOption "Continuwuity Matrix Server" false;
    domain = mkStrOption "The server's domain" "example.com";
  };

  config = mkIf cfg.enable {
    services.matrix-continuwuity = {
      enable = true;
      settings.global = {
        address = "127.0.0.1";
        port = 6761;
        server_name = cfg.domain;

        allow_announcements_check = true;
        allow_encryption = true;
        allow_federation = true;
        allow_registration = false;

        trusted_servers = [ "matrix.org" ];
      };
    };
  };
}
