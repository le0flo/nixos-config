{config, lib, self, ...}:

let
  inherit (builtins) attrNames;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.net.vpn) networks;

  inherit (lib)
    flatten
    genAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  cfg = config.otis.services.microvm;
in {
  options.otis.services.microvm = {
    enable = mkEnableOption "microvm.nix host";

    vms = mkOption {
      type = with types; listOf str;
      description = "List hosted microvms";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.interfaces = genAttrs
      (attrNames networks)
      (name: mkMerge (flatten [
        (map (x: { inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking.firewall) allowedTCPPorts; }) cfg.vms)
        (map (x: { inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking.firewall) allowedUDPPorts; }) cfg.vms)
      ]));

    microvm.vms = genAttrs (map (x: "microvm-${x}-${system}") cfg.vms) (name: {
      autostart = true;
      flake = self;
      restartIfChanged = true;
      updateFlake = null;
    });
  };
}
