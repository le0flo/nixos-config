{lib, ...}:

let
  network = "home";
  vpn = (import ../../vpn/values.nix {}).networks."${network}";

  makeClient = import ../../vpn/client.nix {};
in {
  networking = {
    hostName = "thor";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "${vpn.prefix}.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;
  }
  // makeClient network 3;
}
