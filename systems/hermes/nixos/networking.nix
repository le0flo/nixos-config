{lib, pkgs, ...}: {
  networking = {
    hostName = "hermes";
    useDHCP = lib.mkDefault true;

    nameservers = [ "208.67.222.222" "208.67.220.220" ];

    firewall.enable = false;

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-fortisslvpn ];
    };

    wg-quick.interfaces."home" = {
      privateKeyFile = "/home/leo/.wireguard/private.key";
      address = [ "10.69.0.3/24" ];
      dns = [ "38.242.201.177" ];

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

  # Disables the wg-quick-home service from starting up
  systemd.services."wg-quick-home".wantedBy = lib.mkForce [];

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [ openfortivpn ];
}
