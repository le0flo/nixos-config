{lib, ...}: {
  networking = {
    hostName = "afrodite";
    useDHCP = lib.mkDefault true;

    nameservers = [ "127.0.0.1" "208.67.222.222" "208.67.220.220" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ 53 51820 ];
    };

    networkmanager = {
      enable = true;
      dns = "none";
    };

    wg-quick.interfaces."home" = {
      privateKeyFile = "/home/leo/.wireguard/home";
      address = [ "10.69.0.1/24" ];

      listenPort = 51820;

      peers = [
        {
          publicKey = "GX/1ks+T1OcBsW7XiMIN1k2/azaCWH69eGh9dltfJhU=";
          allowedIPs = [ "10.69.0.2/32" ];
          persistentKeepalive = 25;
        }
        {
          publicKey = "99XBoIZ55yradB45bDZ94fc1IQGkNp9argWaT2otRBU=";
          allowedIPs = [ "10.69.0.3/32" ];
          persistentKeepalive = 25;
        }
        #{
        #  publicKey = "";
        #  allowedIPs = [ "10.69.0.4/32" ];
        #  persistentKeepalive = 25;
        #}
        {
          publicKey = "bMgACe4Pp2VQ0lpMb0Q2RVw/n5KIIg20xT90eesxcEw=";
          allowedIPs = [ "10.69.0.5/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
