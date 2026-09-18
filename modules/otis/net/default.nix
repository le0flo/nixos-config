{hostName, ...}:

{
  imports = [
    ./dns.nix
    ./tls.nix
    ./vpn.nix
    ./wifi.nix
  ];

  config = {
    networking = {
      inherit hostName;

      firewall.enable = true;

      useDHCP = true;
      #useNetworkd = true;
    };

    #systemd.network.enable = true;
  };
}
