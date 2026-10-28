{config, customLib, hostName, lib, ...}:

let
  inherit (customLib.opts)
    mkIntOption
    mkListOption
    mkStrOption;

  inherit (lib) types;

  cfg = config.vmConfig.net;
in {
  options.vmConfig.net = {
    address = mkStrOption "IPv4 address" "";
    prefixLength = mkIntOption "IPv4 prefix lenght" 24;

    gateway = {
      address = mkStrOption "IPv4 gateway address" "";
      prefixLength = mkIntOption "IPv4 gateway prefix lenght" 24;
    };

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

      interfaces."enp4s0".ipv4 = {
        addresses = [{ inherit (cfg) address prefixLength; }];
        routes = [{ inherit (cfg.gateway) address prefixLength; }];
      };

      useDHCP = false;
    };
  };
}
