{config, customLib, lib, self, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    filter
    head
    listToAttrs;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.net.vpn) networks;

  inherit (customLib.net) subnetToPrefix;

  inherit (customLib.opts)
    mkBoolOption
    mkListOption
    mkStrOption;

  inherit (lib)
    drop
    flatten
    genAttrs
    hasPrefix
    last
    mkIf
    mkMerge
    replaceString
    splitString
    take
    toIntBase10
    types
    unique;

  cfg = config.otis.services.microvm;

  allMicrovms = unique (map
    (x: concatStringsSep "-" (take 2 (drop 1 (splitString "-" x))))
    (filter (y: hasPrefix "microvm" y) (attrNames self.nixosConfigurations)));
in {
  options.otis.services.microvm = {
    enable = mkBoolOption "microvm.nix host" false;
    externalInterface = mkStrOption "The interface that microvms use for communications with the outside world" "";
    vms = mkListOption types.str "List hosted microvms" [];
  };

  config = mkIf cfg.enable {
    microvm.vms = (genAttrs
      (map (x: "microvm-${x}-${system}") cfg.vms)
      (name: {
        autostart = true;
        flake = self;
        restartIfChanged = true;
        updateFlake = null;
      }));

    networking.nat = {
      inherit (cfg) externalInterface;

      enable = true;
      enableIPv6 = false;

      internalIPs = [ "10.67.0.0/24" ];
    };

    systemd.network.networks = listToAttrs (map (vmName: {
      name = "40-microvm-${vmName}";
      value = {
        matchConfig.Name = "vm-${vmName}";
        address = [ "10.67.0.0/32" ];

        routes = [{ Destination = "10.67.0.${toString (toIntBase10 (last (splitString "-" vmName)))}/32"; }];

        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = false;
        };
      };
    }) allMicrovms);
  };
}
