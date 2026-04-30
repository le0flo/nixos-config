{lib, ...}: {
  networking = {
    hostName = "afrodite";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "127.0.0.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall = {
      enable = true;

      trustedInterfaces = [ "home" ];

      allowedUDPPorts = [ 51820 ];
    };

    networkmanager = {
      enable = true;
      dns = "none";
    };

    wg-quick.interfaces."home" = {
      privateKeyFile = "/etc/wireguard/home";
      address = [ "10.69.0.1/24" ];

      listenPort = 51820;

      peers = [
        {
          # odino
          publicKey = "GX/1ks+T1OcBsW7XiMIN1k2/azaCWH69eGh9dltfJhU=";
          allowedIPs = [ "10.69.0.2/32" ];
          persistentKeepalive = 25;
        }
        {
          # hermes
          publicKey = "99XBoIZ55yradB45bDZ94fc1IQGkNp9argWaT2otRBU=";
          allowedIPs = [ "10.69.0.3/32" ];
          persistentKeepalive = 25;
        }
        {
          # zeus
          publicKey = "cR1TRWLX8DqZtOEOR7djqlX0ewy648h8oHaZkW9JUjU=";
          allowedIPs = [ "10.69.0.4/32" ];
          persistentKeepalive = 25;
        }
        {
          # ares
          publicKey = "bMgACe4Pp2VQ0lpMb0Q2RVw/n5KIIg20xT90eesxcEw=";
          allowedIPs = [ "10.69.0.5/32" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
