{lib, ...}:

{
  networking = {
    hostName = "thor";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "10.69.0.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;

    wg-quick.interfaces."home" = {
      privateKeyFile = "/etc/wireguard/home";
      address = [ "10.69.0.3/24" ];

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
