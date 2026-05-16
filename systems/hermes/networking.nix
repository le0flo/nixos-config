{lib, pkgs, ...}: {
  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    nameservers = [
      "208.67.222.222"
      "208.67.220.220"
    ];

    firewall.enable = true;

    wireless.iwd.enable = true;

    wg-quick.interfaces."devices" = {
      privateKeyFile = "/etc/wireguard/devices";

      address = [ "10.69.0.2/24" ];
      dns = [ "10.69.0.1" ];

      peers = [
        {
          publicKey = "629xLQgbpcfGJotfD79p3dNbpiwmp2FQtkUMd/S+M2M=";
          allowedIPs = [ "10.69.0.0/24" ];
          endpoint = "leoflo.me:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
