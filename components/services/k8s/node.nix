{...}: let
  masterName = "home.arpa";
  masterIp = "10.69.0.1";
  masterUrl = "https://${masterName}:6443";
in {
  networking.extraHosts = "${masterIp} ${masterName}";

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
