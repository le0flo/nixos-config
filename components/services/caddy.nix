{lib, config, ...}: {
  options.caddy.enable = lib.mkEnableOption "Caddy server";

  config = lib.mkIf config.caddy.enable {
    services.caddy = {
      enable = true;

      virtualHosts = {
        "leoflo.me".extraConfig = ''
          root /srv/leoflo.me/src
          templates
          file_server
        '';

        "files.leoflo.me".extraConfig = ''
          root /srv/files.leoflo.me
          file_server browse
        '';

        "home.arpa".extraConfig = ''
          respond "Benvenuto nella rete privata di leo :D"
          tls internal
        '';
      };
    };
  };
}
