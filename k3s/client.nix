{config, inputs, lib, ...}:

let
  domain = (import ../vpn/values.nix { inherit config inputs lib; }).privateDomain;
in {
  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.age.secrets."k3s/common".path;
    serverAddr = "https://${domain}:6443";
  };
}
