{config, customLib, lib, ...}:

let
  inherit (config.hostConfig.net.dns) domains;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption
    mkPortOption
    mkStrOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.services.k3s;
in {
  options.hostConfig.services.k3s = {
    enable = mkBoolOption "Kubernetes k3s node" false;
    role = mkEnumOption [ "agent" "server" ] "Role of the node" "agent";
    vpnInterface = mkStrOption "VPN interface" "";
    port = mkPortOption "Server's port" 6443;
    address = mkStrOption "Server's address" domains.private;
  };

  config = mkIf cfg.enable {
    networking.firewall.interfaces."${cfg.vpnInterface}".allowedTCPPorts = [ cfg.port ];

    services.k3s = mkMerge [
      {
        inherit (cfg) role;

        enable = true;
        tokenFile = config.age.secrets."k3s/token".path;
      }
      (mkIf (cfg.role == "agent") {
        serverAddr = "https://${cfg.address}:${toString cfg.port}";
      })
      (mkIf (cfg.role == "server") {
        clusterInit = true;

        extraFlags = [
          "--write-kubeconfig-mode=644"
          "--disable=traefik"
          "--disable=servicelb"
        ];
      })
    ];
  };
}
