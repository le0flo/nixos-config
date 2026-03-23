{lib, config, ...}: {
  options.caddy.enable = lib.mkEnableOption "Caddy server";

  config = lib.mkIf config.caddy.enable {
    services.caddy = {
      enable = true;

      virtualHosts = {
        "leoflo.me".extraConfig = ''
          reverse_proxy 127.0.0.1:8001
        '';

        "code.leoflo.me".extraConfig = ''
          reverse_proxy 127.0.0.1:8002
        '';

        "files.leoflo.me".extraConfig = ''
          root /srv/files.leoflo.me
          file_server browse
        '';

        "music.home.leoflo.me".extraConfig = ''
          reverse_proxy 10.69.0.2:9001
        '';

        "cinema.home.leoflo.me".extraConfig = ''
          reverse_proxy 10.69.0.2:9004
        '';

        "home.arpa".extraConfig = ''
          respond "Benvenuto nella rete privata di leo :D"
          tls internal
        '';

        "music.home.arpa".extraConfig = ''
          reverse_proxy 10.69.0.2:9001
          tls internal
        '';

        "images.home.arpa".extraConfig = ''
          reverse_proxy 10.69.0.2:9002
          tls internal
        '';

        "papers.home.arpa".extraConfig = ''
          reverse_proxy 10.69.0.2:9003
          tls internal
        '';

        "cinema.home.arpa".extraConfig = ''
          reverse_proxy 10.69.0.2:9004
          tls internal
        '';

        "torrent.home.arpa".extraConfig = ''
          reverse_proxy 10.69.0.2:9005
          tls internal
        '';
      };
    };
  };
}
