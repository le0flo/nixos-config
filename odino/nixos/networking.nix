{...}: {
  networking = {
    hostName = "odino";
    
    nameservers = [ "208.67.222.222" "208.67.220.220" ];
    networkmanager.enable = true;

    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ 51820 ];
    };

    wireguard.interfaces."tunnel" = {
      ips = [ "10.69.0.2/24" ];

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
