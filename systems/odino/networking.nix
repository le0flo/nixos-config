{lib, ...}:

{
  networking = {
    hostName = "odino";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "10.69.0.1"
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;

    wg-quick.interfaces."home" = {
      privateKeyFile = "/etc/wireguard/home";
      address = [ "10.69.0.2/24" ];

      peers = [
        {
          publicKey = "8sP+w/FRjTU7IC8JSMKrkSAPfi5v4Vs0D1LTdlhnbn4=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
