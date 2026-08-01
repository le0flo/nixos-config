{config, inputs, lib, ...}:

let
  network = "home";
  vpn = (import ../../vpn/values.nix { inherit config inputs lib; }).networks."${network}";

  makeClient = import ../../vpn/client.nix { inherit config inputs lib; };
  client = makeClient network 3;
in {
  networking = lib.mkMerge [
    client
    {
      hostName = "thor";
      useDHCP = lib.mkDefault true;

      nameservers = [
        "${vpn.prefix}.1"
        "208.67.222.222"
        "208.67.220.220"
      ];

      firewall.enable = true;
    }
  ];
}
