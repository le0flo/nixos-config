{config, lib, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    head
    mapAttrs
    replaceStrings;

  inherit (lib)
    last
    mkEnableOption
    mkIf
    mkOption
    splitString
    take
    toInt
    types;
in {
  options.otis.net.vpn =
    let
      networkOpts = {
        options = {
          privateKeyFile = {
            type = types.path;
            description = "Private key file for this host";
            default = ./private.key;
          };

          publicKey = mkOption {
            type = types.str;
            description = "Public key for this host";
            default = "";
          };

          port = mkOption {
            type = types.port;
            description = "The port which the vpn is hosted on";
            default = 51820;
          };

          subnet = mkOption {
            type = types.str;
            description = "Subnet for the vpn";
            default = "10.0.0.0/24";
          };

          primary = mkEnableOption "Whether this is the primary vpn";

          id = mkOption {
            type = types.str;
            description = "Id for this host";
            default = "1";
          };

          clients = mkOption {
            type = types.listOf (types.submodule clientOpts);
            description = "List of allowed clients in the vpn";
            default = [];
          };
        };
      };

      clientOpts = {
        options = {
          publicKey = mkOption {
            type = types.str;
            description = "Public key for this client";
            default = "";
          };

          id = mkOption {
            type = types.str;
            description = "Id for this client";
            default = "1";
          };
        };
      };
    in {
      enable = mkEnableOption "Enable the vpn";

      role = mkOption {
        type = types.enum [ "client" "server" ];
        description = "Role for the host in the vpn";
        default = "client";
      };

      networks = mkOption {
        type = types.attrsOf (types.submodule networkModule);
        description = "Different vpns";
        default = [];
      };
    };

  config =
    let
      net = config.otis.net;
      
      vpn = net.vpn;
      domain = net.dns.domains.public;

      mask = subnet: last (splitString "/" subnet);
      prefix = subnet: concatStringsSep "." (take
        ((toInt (mask subnet)) / 8)
        (splitString "." (head (splitString "/" subnet))));
    in mkIf vpn.enable mkMerge [
      (mkIf vpn.role == "client" {
        wg-quick.interfaces = (mapAttrs
          (x: y: {
            inherit (y) privateKeyFile;
            address = "${prefix y.subnet}.${y.id}/${mask y.subnet}";

            peers = [{
              inherit (y) publicKey;
              allowedIPs = [ y.subnet ];
              endpoint = "${domain}:${toString y.port}";
              persistentKeepalive = 25;
            }];
          })
          vpn.networks);
      })
      (mkIf vpn.role == "server" {
        networking.firewall.allowedUDPPorts = map (x: x.port) (attrValues vpn.networks);

        wg-quick.interfaces = (mapAttrs
          (x: y: {
            inherit (y) privateKeyFile;
            address = "${prefix y.subnet}.${y.id}/${mask y.subnet}";
            listenPort = y.port;

            peers = map
              (z: {
                inherit (z) publicKey;
                allowedIPs = [
                  (replaceStrings
                    [ "/${mask y.subnet}" ]
                    [ "/32" ]
                    y.subnet)
                ];
                persistentKeepalive = 25;
              })
              y.clients;
          })
          vpn.networks);
      })
    ];
}
