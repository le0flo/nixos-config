{...}: let
  masterName = "home.arpa";
  masterUrl = "https://${masterName}:6443";
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
