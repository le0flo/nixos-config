{lib, ...}:

{
  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    resolvconf.enable = true;
    nameservers = [
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "devices" ];
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

    wg-quick.interfaces."devices" = {
      privateKeyFile = "/etc/wireguard/devices";

      address = [ "10.69.0.2/24" ];
      dns = [ "10.69.0.1" ];

      peers = [
        {
          publicKey = "9EsDl0sK6V+Y/MKMlHFZ1qO6VZBWNkQUQKJZujT3bRg=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
