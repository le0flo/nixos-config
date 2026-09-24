{config, customLib, lib, self, ...}:

let
  inherit (builtins)
    attrNames
    concatStringsSep
    filter
    listToAttrs;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.net.vpn) networks;

  inherit (customLib.net) subnetToPrefix;

  inherit (customLib.opts)
    mkBoolOption
    mkListOption
    mkNullOption
    mkStrOption;

  inherit (lib)
    drop
    flatten
    genAttrs
    hasPrefix
    last
    mkDefault
    mkIf
    splitString
    take
    toIntBase10
    types
    unique;

  cfg = config.otis.services.microvm;

  allMicrovms = unique (map
    (x: concatStringsSep "-" (take 2 (drop 1 (splitString "-" x))))
    (filter (y: hasPrefix "microvm" y) (attrNames self.nixosConfigurations)));

  forwardIp = let
    inherit (networks."${cfg.forwardInterface}") id subnet;
  in "${subnetToPrefix subnet}.${id}";

  forwardPorts = flatten (map (x: let
    inherit (self.nixosConfigurations."microvm-${x}-${system}".config.sirah.net) allowedTCPPorts allowedUDPPorts;
  in [
    (map (y: {
      port = y;
      id = idFromName x;
      isUdp = false;
    }) allowedTCPPorts)
    (map (z: {
      port = z;
      id = idFromName x;
      isUdp = true;
    }) allowedUDPPorts)
  ]) cfg.vms);

  idFromName = name: toIntBase10 (last (splitString "-" name));
in {
  options.otis.services.microvm = {
    enable = mkBoolOption "microvm.nix host" false;
    externalInterface = mkStrOption "The interface that microvms use for communications with the outside world" "";
    forwardInterface = mkNullOption types.str "The interface where a reverse proxy contacts the actual microvms" null;
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

    networking = {
      firewall.interfaces."${cfg.forwardInterface}" = {
        allowedTCPPorts = map (x: x.port) (filter (y: y.isUdp == false) forwardPorts);
        allowedUDPPorts = map (x: x.port) (filter (y: y.isUdp == true) forwardPorts);
      };

      nat = {
        inherit (cfg) externalInterface;

        enable = true;
        enableIPv6 = false;

        internalIPs = [ "10.67.0.0/24" ];
      };
    };

    services.nginx = {
      enable = mkDefault (cfg.forwardInterface != null);

      streamConfig = ''
      ${concatStringsSep "\n" (map (x: ''
      server {
        listen ${forwardIp}:${toString x.port} ${if x.isUdp then "udp" else ""};
        proxy_pass 10.67.0.${toString x.id}:${toString x.port};
      }
      '') forwardPorts)}
      '';
    };

    systemd.network.networks = listToAttrs (map (vmName: {
      name = "40-microvm-${vmName}";
      value = {
        matchConfig.Name = "vm-${vmName}";
        address = [ "10.67.0.0/32" ];

        routes = [{ Destination = "10.67.0.${toString (idFromName vmName)}/32"; }];

        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = false;
        };
      };
    }) allMicrovms);
  };
}
