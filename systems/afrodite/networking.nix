{lib, ...}: {
  networking = {
    hostName = "afrodite";
    useDHCP = lib.mkDefault true;

    nameservers = [ "208.67.222.222" "208.67.220.220" ];

    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ 51820 ];
    };

    networkmanager.enable = true;

    wg-quick.interfaces."home" = {
      privateKeyFile = "/home/leo/.wireguard/private.key";
      address = [ "10.69.0.1/24" ];

      peers = [];
    };
  };
}
