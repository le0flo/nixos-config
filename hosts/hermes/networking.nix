{lib, ...}:

let
  network = "home";
  vpn = (import ../../vpn/values.nix {}).networks."${network}";

  makeClient = import ../../vpn/client.nix {};
in {
  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    resolvconf.enable = true;
    nameservers = [
      "${vpn.prefix}.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "home" ];
    };

    wireless.iwd = {
      enable = true;

      settings = {
        General = {
          EnableNetworkConfiguration = true;
          AddressRandomization = "network";
        };

        Network.NameResolvingService = "resolvconf";
      };
    };
  }
  // makeClient network 101;
}
