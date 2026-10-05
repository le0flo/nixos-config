{config, customLib, hostName, lib, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.otis.net;
in {
  imports = [
    ./dns.nix
    ./tls.nix
    ./vpn.nix
    ./wifi.nix
  ];

  options.otis.net = {
    ethernet = {
      static = mkBoolOption "Enable static IPv4 address" false;
      address = mkStrOption "IPv4 address" "10.0.0.67/24";
      gateway = mkStrOption "IPv4 gateway" "10.0.0.1";
    };
    wait-online.enable = mkBoolOption "Wait for a connection to establish" true;
  };

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

          address = mkIf cfg.ethernet.static [ cfg.ethernet.address ];
          routes = mkIf cfg.ethernet.static [{ Gateway = cfg.ethernet.gateway; }];

          networkConfig = {
            DHCP = if cfg.ethernet.static then "no" else "yes";
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
