{config, customLib, hostName, lib, ...}:

let
  inherit (customLib.opts) mkListOption;

  inherit (lib)
    fixedWidthString
    last
    splitString
    toIntBase10
    types;

  cfg = config.sirah.net;

  index = toIntBase10 (last (splitString "-" hostName));
  mac = "02:00:00:00:00:${fixedWidthString 2 "0" (toString index)}";
in {
  options.sirah.net = {
    allowedTCPPorts = mkListOption types.port "List of allowed TCP ports" [];
    allowedUDPPorts = mkListOption types.port "List of allowed UDP ports" [];
  };

  config = {
    microvm = {
      interfaces = [{
        inherit mac;
        type = "tap";
        id = "vm-${hostName}";
      }];

      vsock = {
        cid = 1000 + index;
        ssh.enable = true;
      };
    };

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
        matchConfig.MACAddress = mac;
        address = [ "10.67.0.${toString index}/32" ];

        routes = [
          {
            Destination = "10.67.0.0/32";
            GatewayOnLink = true;
          }
          {
            Destination = "0.0.0.0/0";
            Gateway = "10.67.0.0";
            GatewayOnLink = true;
          }
        ];

        networkConfig.DNS = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };
}
