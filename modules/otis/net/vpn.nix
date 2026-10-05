{config, customLib, lib, ...}:

let
  inherit (builtins)
    attrValues
    mapAttrs;

  inherit (config.otis.net.dns) domains;

  inherit (customLib.net)
    subnetToMask
    subnetToPrefix;

  inherit (customLib.opts)
    mkAttrSubOption
    mkBoolOption
    mkEnumOption
    mkListSubOption
    mkPortOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.net.vpn;

  clientOpts.options = {
    publicKey = mkStrOption "Public key" "";
    id = mkStrOption "Client's ID" "1";
  };

  networkOpts.options = {
    privateKeyFile = mkStrOption "Private key file" "/run/secrets/wg.key";
    publicKey = mkStrOption "Public key" "";
    address = mkStrOption "Server's address" domains.public;
    port = mkPortOption "Server's port" 51820;
    subnet = mkStrOption "VPN's subnet" "10.0.0.0/24";
    primary = mkBoolOption "Whether this is the primary network on the host" false;
    id = mkStrOption "Host's ID" "1";
    clients = mkListSubOption clientOpts "List of clients" [];
  };
in {
  options.otis.net.vpn = {
    enable = mkBoolOption "Enables VPN" false;
    role = mkEnumOption [ "client" "server" ] "Host's role in the VPN" "client";
    networks = mkAttrSubOption networkOpts "Network definitions" {};
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "client") {
      networking.wg-quick.interfaces = (mapAttrs (x: y: {
        inherit (y) privateKeyFile;
        address = [ "${subnetToPrefix y.subnet}.${y.id}/${subnetToMask y.subnet}" ];

        peers = [{
          inherit (y) publicKey;
          allowedIPs = [ y.subnet ];
          endpoint = "${y.address}:${toString y.port}";
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
