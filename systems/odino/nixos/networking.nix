{lib, ...}: {
  networking = {
    hostName = "odino";
    useDHCP = lib.mkDefault true;

    nameservers = [ "208.67.222.222" "208.67.220.220" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 51820 ];
    };

    networkmanager.enable = true;

    wg-quick.interfaces."tunnel" = {
      privateKeyFile = "/home/leo/.wireguard/private.key";
      address = [ "10.69.0.2/24" ];

      peers = [
        {
          publicKey = "rwUMCdhjQbQt9uGjljfdABj4DSJFgL62bzT13sg8LmU=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
