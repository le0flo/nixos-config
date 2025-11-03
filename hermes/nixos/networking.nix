{...}: {
  networking = {
    hostName = "hermes";

    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    networkmanager.enable = true;

    firewall.enable = false;

    wireguard.interfaces."home" = {
      ips = [ "10.69.0.3/24" ];

      privateKeyFile = "/home/leo/.wireguard/private.key";

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
