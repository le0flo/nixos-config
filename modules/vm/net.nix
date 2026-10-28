{config, customLib, hostName, lib, ...}:

let
  inherit (customLib.opts)
    mkListOption
    mkStrOption;

  inherit (lib) types;

  cfg = config.vmConfig.net;
in {
  options.vmConfig.net = {
    address = mkStrOption "IPv4 address" "10.0.0.76/24";
    gateway = mkStrOption "IPv4 gateway" "10.0.0.1";

    allowedTCPPorts = mkListOption types.port "List of allowed TCP ports" [];
    allowedUDPPorts = mkListOption types.port "List of allowed UDP ports" [];
  };

  config = {
    networking = {
      inherit hostName;

      firewall = {
        inherit (cfg) allowedTCPPorts allowedUDPPorts;
        enable = true;
      };

      useDHCP = false;
      useNetworkd = true;
    };

    systemd.network = {
      enable = true;
      wait-online.enable = true;

      networks."10-ethernet" = {
        matchConfig.Name = "en*";

        address = [ cfg.address ];
        routes = [{ Gateway = cfg.gateway; }];

        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = true;
        };
      };
    };
  };
}
