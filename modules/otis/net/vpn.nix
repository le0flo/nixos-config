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
    mkMerge
    mkOption
    splitString
    take
    toInt
    types;

  net = config.otis.net;
  
  vpn = net.vpn;
  domain = net.dns.domains.public;

  networkOpts = {
    options = {
      privateKeyFile = mkOption {
        type = types.str;
        description = "Private key file for this host";
        default = "/run/secrets/private.key";
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
        type = with types; listOf (submodule clientOpts);
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

  mask = subnet: last (splitString "/" subnet);
  prefix = subnet: concatStringsSep "." (take
    ((toInt (mask subnet)) / 8)
    (splitString "." (head (splitString "/" subnet))));
in {
  options.otis.net.vpn = {
    enable = mkEnableOption "Enable the vpn";

    role = mkOption {
      type = types.enum [ "client" "server" ];
      description = "Role for the host in the vpn";
      default = "client";
    };

    networks = mkOption {
      type = with types; attrsOf (submodule networkOpts);
      description = "Different vpns";
      default = {};
    };
  };

  config = mkIf vpn.enable (mkMerge [
    (mkIf (vpn.role == "client") {
      boot.kernel.sysctl."net.ipv4.ip_forward" = true;

      networking.wg-quick.interfaces = (mapAttrs
        (x: y: {
          inherit (y) privateKeyFile;
          address = [ "${prefix y.subnet}.${y.id}/${mask y.subnet}" ];

          peers = [{
            inherit (y) publicKey;
            allowedIPs = [ y.subnet ];
            endpoint = "${domain}:${toString y.port}";
            persistentKeepalive = 25;
          }];
        })
        vpn.networks);
    })
    (mkIf (vpn.role == "server") {
      networking = {
        firewall.allowedUDPPorts = map (x: x.port) (attrValues vpn.networks);

        wg-quick.interfaces = (mapAttrs
          (x: y: {
            inherit (y) privateKeyFile;
            address = [ "${prefix y.subnet}.${y.id}/${mask y.subnet}" ];
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
      };
    })
  ]);
}
