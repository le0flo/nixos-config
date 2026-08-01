{lib, ...}:

let
  network = "home";
  vpn = (import ../../vpn/values.nix {}).networks."${network}";

  makeClient = import ../../vpn/client.nix {};
  client = makeClient network 2;
in {
  networking = lib.mkMerge [
    client
    {
      hostName = "odino";
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
