{lib, ...}: {
  networking = {
    hostName = "odino";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall = {
      enable = true;

      trustedInterfaces = [ "home" ];

      allowedUDPPorts = [ 51820 ];
    };

    networkmanager.enable = true;

    wg-quick.interfaces."home" = {
      privateKeyFile = "/etc/wireguard/home";
      address = [ "10.69.0.2/24" ];
      dns = [ "10.69.0.1" ];

      peers = [
        {
          publicKey = "629xLQgbpcfGJotfD79p3dNbpiwmp2FQtkUMd/S+M2M=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
