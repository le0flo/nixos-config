{config, customLib, hostName, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  cfg = config.otis.net;
in {
  imports = [
    ./dns.nix
    ./tls.nix
    ./vpn.nix
    ./wifi.nix
  ];

  options.otis.net.wait-online.enable = mkBoolOption "Wait for a connection to establish" true;

  config = {
    networking = {
      inherit hostName;

      firewall.enable = true;

      useDHCP = false;
      useNetworkd = true;
    };

    systemd.network = {
      inherit (cfg) wait-online;

      enable = true;

      networks = {
        "10-ethernet" = {
          matchConfig.Name = "en*";

          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
        };

        "20-wireless" = {
          matchConfig.Name = "wl*";
          linkConfig.RequiredForOnline = "no";

          networkConfig = {
            DHCP = "yes";
            IPv6AcceptRA = true;
          };
        };
      };
    };
  };
}
