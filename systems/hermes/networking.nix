{lib, ...}:

{
  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    resolvconf.enable = true;
    nameservers = [
      "10.69.0.1"
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

    wg-quick.interfaces."home" = {
      privateKeyFile = "/etc/wireguard/home";
      address = [ "10.69.0.101/24" ];

      peers = [
        {
          publicKey = "9EsDl0sK6V+Y/MKMlHFZ1qO6VZBWNkQUQKJZujT3bRg=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
