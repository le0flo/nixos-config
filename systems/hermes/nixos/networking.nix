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
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
}
