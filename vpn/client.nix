{...}:

let
  domain = (import ./values.nix {}).publicDomain;
  networks = (import ./values.nix {}).networks;
in name: id: let
  vpn = networks."${name}";
in {
  wg-quick.interfaces."${name}" = {
    privateKeyFile = vpn.privateKey;
    address = [ "${vpn.prefix}.${toString id}/24" ];

    peers = [
      {
        publicKey = vpn.publicKey;
        allowedIPs = [ "${vpn.prefix}.0/24" ];
        endpoint = "${domain}:${toString vpn.port}";
        persistentKeepalive = 25;
      }
    ];
  };
}
