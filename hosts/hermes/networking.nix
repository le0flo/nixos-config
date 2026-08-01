{config, inputs, lib, ...}:

let
  network = "home";
  vpn = (import ../../vpn/values.nix { inherit config inputs lib; }).networks."${network}";

  makeClient = import ../../vpn/client.nix { inherit config inputs lib; };
  client = makeClient network 101;
in {
  networking = lib.mkMerge [
    client
    {
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
  ];
}
