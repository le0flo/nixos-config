{lib, ...}:

{
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
      allowedUDPPorts = [
        51820
        51821
      ];
    };

    wg-quick.interfaces = {
      "home" = {
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
            # nettuno
            publicKey = "O0qmhfzHIvEQjnr8sttLfur7uZ7+u72BNoWEyo2pmX0=";
            allowedIPs = [ "10.69.0.3/32" ];
            persistentKeepalive = 25;
          }
          {
            # hermes
            publicKey = "99XBoIZ55yradB45bDZ94fc1IQGkNp9argWaT2otRBU=";
            allowedIPs = [ "10.69.0.101/32" ];
            persistentKeepalive = 25;
          }
          {
            # zeus
            publicKey = "cR1TRWLX8DqZtOEOR7djqlX0ewy648h8oHaZkW9JUjU=";
            allowedIPs = [ "10.69.0.102/32" ];
            persistentKeepalive = 25;
          }
          {
            # ares
            publicKey = "vdQbZ0/xbQnGlyPRFEC4gugOXaVPyF6n0vHVAlyLFjU=";
            allowedIPs = [ "10.69.0.103/32" ];
            persistentKeepalive = 25;
          }
        ];
      };

      "external" = {
        privateKeyFile = "/etc/wireguard/external";
        address = [ "10.96.0.1/24" ];
        listenPort = 51821;

        peers = [
          {
            # firetv
            publicKey = "RD/w5EMw16BFWTbbsG2XIoXvPAxubDVmOjbzjWK2XF4=";
            allowedIPs = [ "10.96.0.2/32" ];
            persistentKeepalive = 25;
          }
          {
            # mybaby
            publicKey = "4o9ANbaAHabP1vJ2jaHLCePaFmELpyEX2ymkX6nJ/S0=";
            allowedIPs = [ "10.96.0.3/32" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
