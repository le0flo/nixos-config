{config, customLib, lib, ...}:

let
  inherit (config.age) secretsDir;

  inherit (config.hostConfig.net) vpn;

  inherit (config.hostConfig.net.dns) domains;

  inherit (customLib.net) subnetToGateway;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.services.hydra;
in {
  options.hostConfig.services.hydra = {
    enable = mkBoolOption "Hydra cluster" false;
    role = mkEnumOption [ "server" "builder" ] "Role of the host" "builder";
    vpnInterface = mkStrOption "VPN interface" "";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.role == "server") {
      networking.firewall.interfaces."${cfg.vpnInterface}".allowedTCPPorts = [ 9001 ];

      services.hydra = {
        enable = true;
        useSubstitutes = true;
        hydraURL = "https://hydra.${domains.public}";
        listenHost = "127.0.0.1";
        port = 9000;
        notificationSender = "hydra@localhost";

        queueRunner = {
          grpc = {
            address = subnetToGateway vpn.networks."${cfg.vpnInterface}".subnet;
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
        queueRunnerAddr = "http://${subnetToGateway vpn.networks."${cfg.vpnInterface}".subnet}:9001";
        authorizationFile = "${secretsDir}/hydra/token";
      };
    })
  ]);
}
