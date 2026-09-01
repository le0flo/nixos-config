{config, lib, self, ...}:

let
  inherit (builtins)
    attrNames
    attrValues
    concatStringsSep
    head;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.net.vpn) networks;

  inherit (lib)
    flatten
    genAttrs
    last
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    replaceString
    splitString
    take
    toInt
    types;

  cfg = config.otis.services.microvm;

  vmAddrFromGateway = gateway: "${concatStringsSep "." (take 3 (splitString "." gateway))}.2";
  vmSubFromGateway = gateway: "${concatStringsSep "." (take 3 (splitString "." gateway))}.0/30";
  mask = subnet: last (splitString "/" subnet);
  prefix = subnet: concatStringsSep "." (take
    ((toInt (mask subnet)) / 8)
    (splitString "." (head (splitString "/" subnet))));

  forwardRule = proto: gateway: port: {
    inherit proto;
    sourcePort = port;
    destination = "${vmAddrFromGateway gateway}:${toString port}";
    loopbackIPs = map (x: "${prefix x.subnet}.${x.id}") (attrValues networks);
  };

  snatRule = stop: proto: subnet: gateway: port: ''
  iptables -t nat -${if stop then "D" else "A"} POSTROUTING \
    -j SNAT \
    -p ${proto} \
    -s ${subnet} \
    -d ${vmAddrFromGateway gateway} \
    --dport ${toString port} \
    --to-source ${gateway} ${if stop then "|| true" else ""}
  '';

  masqueradeRule = stop: gateway: ''
  iptables -t nat -${if stop then "D" else "A"} POSTROUTING \
    -j MASQUERADE \
    -s ${vmSubFromGateway gateway} \
    -o ${cfg.externalInterface} ${if stop then "|| true" else ""}
  '';
in {
  options.otis.services.microvm = {
    enable = mkEnableOption "microvm.nix host";

    externalInterface = mkOption {
      type = types.str;
      description = "The interface that microvms use for communications with the outside world";
      default = "";
    };

    vms = mkOption {
      type = with types; listOf str;
      description = "List hosted microvms";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        interfaces = genAttrs
          (attrNames networks)
          (name: mkMerge (flatten (map (x: let
            inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking) firewall;
          in [
            { inherit (firewall) allowedTCPPorts; }
            { inherit (firewall) allowedUDPPorts; }
          ]) cfg.vms)));

        trustedInterfaces = map (x: "vm-${x}") cfg.vms;
      };

      interfaces = genAttrs
        (map (x: "vm-${x}") cfg.vms)
        (name: {
          ipv4.addresses = [
            {
              inherit (self.nixosConfigurations."micro${name}-${system}".config.networking.defaultGateway) address;
              prefixLength = 30;
            }
          ];
        });

      nat = {
        enable = true;

        externalInterface = "home";
        internalInterfaces = map (x: "vm-${x}") cfg.vms;

        extraCommands = concatStringsSep "\n" (flatten (map
          (x: let
            inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking) defaultGateway firewall;
            inherit (networks."${config.networking.nat.externalInterface}") subnet;
          in [
            (masqueradeRule false defaultGateway.address)
            (map (y: snatRule false "tcp" subnet defaultGateway.address y) firewall.allowedTCPPorts)
            (map (y: snatRule false "udp" subnet defaultGateway.address y) firewall.allowedUDPPorts)
          ])
          cfg.vms));

        extraStopCommands = concatStringsSep "\n" (flatten (map
          (x: let
            inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking) defaultGateway firewall;
            inherit (networks."${config.networking.nat.externalInterface}") subnet;
          in [
            (masqueradeRule true defaultGateway.address)
            (map (y: snatRule true "tcp" subnet defaultGateway.address y) firewall.allowedTCPPorts)
            (map (y: snatRule true "udp" subnet defaultGateway.address y) firewall.allowedUDPPorts)
          ])
          cfg.vms));

        forwardPorts = flatten (map
          (x: let
            inherit (self.nixosConfigurations."microvm-${x}-${system}".config.networking) defaultGateway firewall;
          in [
            (map (y: forwardRule "tcp" defaultGateway.address y) firewall.allowedTCPPorts)
            (map (y: forwardRule "udp" defaultGateway.address y) firewall.allowedUDPPorts)
          ]) cfg.vms);
      };
    };

    microvm.vms = genAttrs (map (x: "microvm-${x}-${system}") cfg.vms) (name: {
      autostart = true;
      flake = self;
      restartIfChanged = true;
      updateFlake = null;
    });
  };
}
