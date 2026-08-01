{config, inputs, lib, ...}:

let
  networks = (import ./values.nix { inherit config inputs lib; }).networks;

  makePeer = name: publicKey: id: let
    vpn = networks."${name}";
  in {
    inherit publicKey;

    allowedIPs = [ "${vpn.prefix}.${toString id}/32" ];
    persistentKeepalive = 25;    
  };
in name: peers: let
  vpn = networks."${name}";
in {
  firewall.allowedUDPPorts = [ vpn.port ];

  wg-quick.interfaces."${name}" = {
    privateKeyFile = vpn.privateKeyFile;
    address = [ "${vpn.prefix}.1/24" ];
    listenPort = vpn.port;

    peers = map
      (x: makePeer name x.publicKey x.id)
      peers;
  };
}
