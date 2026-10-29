{config, customLib, lib, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    listToAttrs;

  inherit (config.hostConfig.net.dns)
    domains
    vpnInterface;

  inherit (customLib.net)
    subnetToGateway
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
    imap
    mkIf
    mkMerge;

  cfg = config.hostConfig.net.vpn;

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
    id = mkStrOption "Host's ID" "1";
    clients = mkListSubOption clientOpts "List of clients" [];
  };
in {
  options.hostConfig.net.vpn = {
    enable = mkBoolOption "Enables VPN" false;
    role = mkEnumOption [ "client" "server" ] "Host's role in the VPN" "client";
    networks = mkAttrSubOption networkOpts "Network definitions" {};
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "client") {
      systemd.network = {
        networks = listToAttrs (imap (i: x: let
          y = cfg.networks."${x}";
          found = (x == vpnInterface);
        in {
          name = "${toString (30 + i)}-vpn";
          value = {
            matchConfig.Name = x;
            address = [ "${subnetToPrefix y.subnet}.${y.id}/${subnetToMask y.subnet}" ];

            dns = if found then [ (subnetToGateway y.subnet) ] else [];
            domains = if found then [ "~${domains.private}" ] else [];
          };
        }) (attrNames cfg.networks));

        netdevs = listToAttrs (imap (i: x: let
          y = cfg.networks."${x}";
        in {
          name = "${toString (30 + i)}-vpn";
          value = {
            netdevConfig = {
              Kind = "wireguard";
              Name = x;
            };

            wireguardConfig.PrivateKeyFile = y.privateKeyFile;
            wireguardPeers = [{
              PublicKey = y.publicKey;
              AllowedIPs = [ y.subnet ];
              Endpoint = "${y.address}:${toString y.port}";
              PersistentKeepalive = 10;
            }];
          };
        }) (attrNames cfg.networks));
      };
    })
    (mkIf (cfg.role == "server") {
      boot.kernel.sysctl."net.ipv4.ip_forward" = true;

      networking.firewall.allowedUDPPorts = map (x: x.port) (attrValues cfg.networks);

      systemd.network = {
        networks = listToAttrs (imap (i: x: let
          y = cfg.networks."${x}";
          found = (x == vpnInterface);
        in {
          name = "${toString (30 + i)}-vpn";
          value = {
            matchConfig.Name = x;
            address = [ "${subnetToPrefix y.subnet}.${y.id}/${subnetToMask y.subnet}" ];

            dns = if found then [ (subnetToGateway y.subnet) ] else [];
            domains = if found then [ "~${domains.private}" ] else [];
          };
        }) (attrNames cfg.networks));

        netdevs = listToAttrs (imap (i: x: let
          y = cfg.networks."${x}";
        in {
          name = "${toString (30 + i)}-vpn";
          value = {
            netdevConfig = {
              Kind = "wireguard";
              Name = x;
            };

            wireguardConfig = {
              ListenPort = y.port;
              PrivateKeyFile = y.privateKeyFile;
            };

            wireguardPeers = map (z: {
              PublicKey = z.publicKey;
              AllowedIPs = [ "${subnetToPrefix y.subnet}.${z.id}/32" ];
              PersistentKeepalive = 10;
            }) y.clients;
          };
        }) (attrNames cfg.networks));
      };
    })
  ]);
}
