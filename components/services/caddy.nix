{lib, config, ...}: {
  options.caddy.enable = lib.mkEnableOption "Caddy server";

  config = lib.mkIf config.caddy.enable {
    services.caddy = {
      enable = true;

      virtualHosts."leoflo.me".extraConfig = ''
        respond "Hello, world!"
      '';
    };
  };
}
