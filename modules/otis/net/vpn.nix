{config, lib, ...}:

{
  options.otis.www.vpn =
    with lib;
    let
      t = types;

      networkOpts = {
        options = {
          privateKeyFile = {
            type = t.path;
            description = "Private key file for this host";
            default = ./private.key;
          };

          publicKey = mkOption {
            type = t.str;
            description = "Public key for this host";
            default = "";
          };

          port = mkOption {
            type = t.port;
            description = "The port which the vpn is hosted on";
            default = 51820;
          };

          subnet = mkOption {
            type = t.str;
            description = "Subnet for the vpn";
            default = "10.0.0.0/24";
          };

          primary = mkEnableOption "Whether this is the primary vpn";

          id = mkOption {
            type = t.str;
            description = "Id for this host";
            default = "1";
          };

          clients = mkOption {
            type = t.listOf (t.submodule clientOpts);
            description = "List of allowed clients in the vpn";
            default = [];
          };
        };
      };

      clientOpts = {
        options = {
          publicKey = mkOption {
            type = t.str;
            description = "Public key for this client";
            default = "";
          };

          id = mkOption {
            type = t.str;
            description = "Id for this client";
            default = "1";
          };
        };
      };
    in {
      enable = mkEnableOption "Enable the vpn";

      role = mkOption {
        type = t.enum [ "client" "server" ];
        description = "Role for the host in the vpn";
        default = "client";
      };

      networks = mkOption {
        type = t.attrsOf (t.submodule networkModule);
        description = "Different vpns";
        default = [];
      };
    };

  config =
    with lib;
    let
      vpn = config.otis.www.vpn;

      prefix = subnet: lib.concatStringsSep "." (lib.take
        ((lib.toInt (lib.last (lib.splitString "/" subnet))) / 8)
        (lib.splitString "." (lib.head (lib.splitString "/" subnet))));

      mask = subnet: lib.last (lib.splitString "/" subnet);
    in mkIf vpn.enable mkMerge [
      (mkIf vpn.role == "client" {
        wg-quick.interfaces = (mapAttrs
          (x: y: {
            inherit (y) privateKeyFile;
            address = "${prefix y.subnet}.${y.id}/${mask y.subnet}";

            peers = [{
              inherit (y) publicKey;
              allowedIPs = [ y.subnet ];
              endpoint = "${config.otis.www.dns.domains.public}:${toString y.port}";
              persistentKeepalive = 25;
            }];
          })
          config.otis.www.vpn.networks);
      })
      (mkIf vpn.role == "server" {
        wg-quick.interfaces = (mapAttrs
          (x: y: {
            inherit (y) privateKeyFile;
            address = "${prefix y.subnet}.${y.id}/${mask y.subnet}";
            listenPort = y.port;

            peers = map
              (z: {
                inherit (z) publicKey;
                allowedIPs = [ lib.replaceString "/${mask y.subnet}" "/32" y.subnet ];
                persistentKeepalive = 25;
              })
              y.clients;
          })
          config.otis.www.vpn.networks);
      })
    ];
}
