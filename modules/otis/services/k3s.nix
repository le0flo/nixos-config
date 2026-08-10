{config, lib, ...}:

let
  inherit (builtins) attrNames;
  
  inherit (lib)
    filterAttrs
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.services.k3s = {
    enable = mkEnableOption "Kubernetes k3s node";

    role = mkOption {
      type = types.enum [ "agent" "server" ];
      description = "The role of the k3s node";
      default = "agent";
    };

    port = mkOption {
      type = types.port;
      description = "The port the k3s cluster api is hosted on";
      default = 6443;
    };
  };

  config =
    let
      k3s = config.otis.services.k3s;

      domain = config.otis.net.dns.domains.private;
      vpn = config.otis.net.vpn;

      forPrimaryVpn = attrs: map (x: attrs x) (attrNames (filterAttrs (_: y: y.primary) vpn.networks));
    in mkMerge [
      {
        services.k3s = mkMerge [
          {
            inherit (k3s) enable role;
            tokenFile = config.age.secrets."k3s/token".path;
          }
          (mkIf k3s.role == "agent" {
            serverAddr = "https://${domain}:${toString k3s.port}";
          })
          (mkIf k3s.role == "server" {
            clusterInit = true;

            extraFlags = [
              "--write-kubeconfig-mode=644"
              "--disable-traefik"
              "--disable-servicelb"
            ];
          })
        ];
      }
    ]
    ++ mkIf (k3s.enable && k3s.role == "server") forPrimaryVpn (name: {
      networking.firewall.interfaces."${name}".allowedTCPPorts = [ 6443 ];
    });
}
