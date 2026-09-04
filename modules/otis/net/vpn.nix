{config, customLibs, lib, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    head
    mapAttrs;

  inherit (config.otis.net.dns) domains;

  inherit (customLibs.otis.net)
    subnetToMask
    subnetToPrefix;

  inherit (customLibs.otis.opts)
    mkAttrSubOption
    mkBoolOption
    mkEnumOption
    mkListSubOption
    mkPortOption
    mkStrOption;

  inherit (lib)
    last
    mkIf
    mkMerge
    splitString
    take
    toInt;

  cfg = config.otis.net.vpn;

  clientOpts.options = {
    publicKey = mkStrOption "Public key for this client" "";
    id = mkStrOption "Id for this client" "1";
  };

  networkOpts.options = {
    privateKeyFile = mkStrOption "Private key file for this host" "/run/secrets/private.key";
    publicKey = mkStrOption "Public key for this host" "";
    port = mkPortOption "The port which the vpn is hosted on" 51820;
    subnet = mkStrOption "Subnet for the vpn" "10.0.0.0/24";
    primary = mkBoolOption "Whether this is the primary vpn" false;
    id = mkStrOption "Id for this host" "1";
    clients = mkListSubOption clientOpts "List of allowed clients in the vpn" [];
  };
in {
  options.otis.net.vpn = {
    enable = mkBoolOption "Enable the vpn" false;
    role = mkEnumOption [ "client" "server" ] "Role for the host in the vpn" "client";
    networks = mkAttrSubOption networkOpts "Different vpns" {};
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "client") {
      networking.wg-quick.interfaces = (mapAttrs (x: y: {
        inherit (y) privateKeyFile;
        address = [ "${subnetToPrefix y.subnet}.${y.id}/${subnetToMask y.subnet}" ];

        peers = [{
          inherit (y) publicKey;
          allowedIPs = [ y.subnet ];
          endpoint = "${domains.public}:${toString y.port}";
          persistentKeepalive = 25;
        }];
      }) cfg.networks);
    })
    (mkIf (cfg.role == "server") {
      boot.kernel.sysctl."net.ipv4.ip_forward" = true;

      networking = {
        firewall.allowedUDPPorts = map (x: x.port) (attrValues cfg.networks);

        wg-quick.interfaces = (mapAttrs (x: y: {
          inherit (y) privateKeyFile;
          address = [ "${subnetToPrefix y.subnet}.${y.id}/${subnetToMask y.subnet}" ];
          listenPort = y.port;

          peers = map (z: {
            inherit (z) publicKey;
            allowedIPs = [ "${subnetToPrefix y.subnet}.${z.id}/32" ];
            persistentKeepalive = 25;
          }) y.clients;
        }) cfg.networks);
      };
    })
  ]);
}
