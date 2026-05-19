{lib, ...}:

{
  networking = {
    hostName = "odino";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;

    wg-quick.interfaces."homelab" = {
      privateKeyFile = "/etc/wireguard/homelab";

      address = [ "10.67.0.2/24" ];
      dns = [ "10.67.0.1" ];

      peers = [
        {
          publicKey = "2UAg2sFcQSt5bgfVFCOVNH6fmWjOwBI4ba1vDS4I3yE=";
          allowedIPs = [ "10.67.0.0/24" ];
          endpoint = "leoflo.me:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
