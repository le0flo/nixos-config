{...}: let
  domainName = "leoflo.me";
in {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;

    virtualHosts = {
      "${domainName}" = {
        useACMEHost = domainName;
        extraConfig = ''
          handle /.well-known/acme-challenge/* {
            root * /var/lib/acme/acme-challenge
            file_server
          }

          handle {
            reverse_proxy 10.69.0.2:9000
          }
        '';
      };

      "files.${domainName}" = {
        useACMEHost = domainName;
        extraConfig = ''
          handle /.well-known/acme-challenge/* {
            root * /var/lib/acme/acme-challenge
            file_server
          }

          handle {
            root /srv/files.leoflo.me
            file_server browse
          }
        '';
      };

      # XMPP
      "xmpp.${domainName}".extraConfig = ''
        handle /.well-known/acme-challenge/* {
          root * /var/lib/acme/acme-challenge
          file_server
        }

        handle {
          respond "Il server XMPP è soltanto mio :P"
        }
      '';

      "muc.xmpp.${domainName}".extraConfig = ''
        handle /.well-known/acme-challenge/* {
          root * /var/lib/acme/acme-challenge
          file_server
        }

        handle {
          respond "Il server XMPP è soltanto mio :P"
        }
      '';

      "turn.xmpp.${domainName}".extraConfig = ''
        handle /.well-known/acme-challenge/* {
          root * /var/lib/acme/acme-challenge
          file_server
        }

        handle {
          respond "Il server XMPP è soltanto mio :P"
        }
      '';

      # Internal network
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

      "music.home.${domainName}" = {
        useACMEHost = domainName;
        extraConfig = ''
          handle /.well-known/acme-challenge/* {
            root * /var/lib/acme/acme-challenge
            file_server
          }

          handle {
            reverse_proxy 10.69.0.2:9001
          }
        '';
      };

      "cinema.home.${domainName}" = {
        useACMEHost = domainName;
        extraConfig = ''
          handle /.well-known/acme-challenge/* {
            root * /var/lib/acme/acme-challenge
            file_server
          }

          handle {
            reverse_proxy 10.69.0.2:9004
          }
        '';
      };
    };
  };
}
