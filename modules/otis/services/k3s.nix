{config, customLibs, lib, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (config.otis.net.dns) domains;

  inherit (config.otis.net) vpn;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkEnumOption
    mkPortOption;

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
  };

  config = {
    networking.firewall.interfaces = mapAttrs
      (_: _: { allowedTCPPorts = [ cfg.port ]; })
      (filterAttrs (_: x: x.primary) vpn.networks);
    
    services.k3s = mkMerge [
      {
        inherit (cfg) enable role;
        tokenFile = config.age.secrets."k3s/token".path;
      }
      (mkIf (cfg.role == "agent") {
        serverAddr = "https://${domains.private}:${toString cfg.port}";
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
