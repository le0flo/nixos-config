{config, customLib, lib, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (config.otis.net.dns) domains;

  inherit (config.otis.net) vpn;

  inherit (customLib.opts)
    mkBoolOption
    mkEnumOption
    mkPortOption
    mkStrOption;

  inherit (lib)
    filterAttrs
    mkIf
    mkMerge;

  cfg = config.otis.services.k3s;
in {
  options.otis.services.k3s = {
    enable = mkBoolOption "Kubernetes k3s node" false;
    role = mkEnumOption [ "agent" "server" ] "The role of the k3s node" "agent";
    port = mkPortOption "The port the k3s cluster api is hosted on" 6443;
    address = mkStrOption "The address the k3s cluster api is hosted on" domains.private;
  };

  config = mkIf cfg.enable {
    networking.firewall.interfaces = mapAttrs
      (_: _: { allowedTCPPorts = [ cfg.port ]; })
      (filterAttrs (_: x: x.primary) vpn.networks);
    
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
