{config, inputs, lib, ...}:

let
  networks = (import ../vpn/values.nix { inherit config inputs lib; }).networks;

  firewallRule = map (x: {
    interfaces."${x}".allowedTCPPorts = [ 6443 ];
  })
    (lib.attrNames
      (lib.filterAttrs (x: { primary ? false, ... }: primary) networks));
in {
  networking.firewall = lib.mkMerge firewallRule;

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.age.secrets."k3s/common".path;
    clusterInit = true;

    extraFlags = [
      "--write-kubeconfig-mode=644"
      "--disable=traefik"
      "--disable=servicelb"
    ];
  };
}
