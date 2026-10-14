{config, customLib, lib, ...}:

let
  inherit (builtins) attrValues;

  inherit (config.age) secretsDir;

  inherit (config.otis.net) vpn;

  inherit (config.otis.net.dns) domains;

  inherit (customLib.net) subnetToGateway;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption;

  inherit (lib)
    filterAttrs
    head
    mapAttrs
    mkIf
    mkMerge;

  cfg = config.otis.services.hydra;
in {
  options.otis.services.hydra = {
    enable = mkBoolOption "Hydra cluster" false;
    role = mkEnumOption [ "server" "builder" ] "Role of the host" "builder";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "server") {
      networking.firewall.interfaces = mapAttrs
        (_: _: { allowedTCPPorts = [ 9001 ]; })
        (filterAttrs (_: x: x.primary) vpn.networks);

      services.hydra = {
        enable = true;
        useSubstitutes = true;
        hydraURL = "https://hydra.${domains.public}";
        listenHost = "127.0.0.1";
        port = 9000;
        notificationSender = "hydra@localhost";

        queueRunner = {
          grpc = {
            address = subnetToGateway (head (attrValues (filterAttrs (_: x: x.primary) vpn.networks))).subnet;
            port = 9001;
          };

          settings.tokenPaths = [ "${secretsDir}/hydra/token" ];
        };
      };
    })
    (mkIf (cfg.role == "builder") {
      services.hydra-builder = {
        enable = true;
        settings.useSubstitutes = true;
        queueRunnerAddr = "http://${subnetToGateway (head (attrValues (filterAttrs (_: x: x.primary) vpn.networks))).subnet}:9001";
        authorizationFile = "${secretsDir}/hydra/token";
      };
    })
  ]);
}
