{config, inputs, lib, ...}:

let
  values = import ./values.nix { inherit config inputs lib; };

  domain = values.publicDomain;
  networks = values.networks;
in name: id: let
  vpn = networks."${name}";
in {
  wg-quick.interfaces."${name}" = {
    privateKeyFile = vpn.privateKeyFile;
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
