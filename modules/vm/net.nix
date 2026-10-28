{config, customLib, hostName, lib, ...}:

let
  inherit (customLib.opts) mkListOption;

  inherit (lib) types;

  cfg = config.vmConfig.net;
in {
  options.vmConfig.net = {
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

      useDHCP = true;
    };
  };
}
