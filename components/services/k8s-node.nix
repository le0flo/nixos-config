{...}: let
  masterName = "home.arpa";
  masterPort = 6443;
  masterUrl = "http://${masterName}:${tostring masterPort}";
in {
  services.kubernetes = {
    roles = ["node"];
    easyCerts = true;

    masterAddress = masterName;
    apiserverAddress = masterUrl;

    kubelet = {
      kubeconfig.server = masterUrl;

      extraOpts = "--fail-swap-on=false";
    };
  };
}
