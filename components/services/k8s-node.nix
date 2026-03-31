{...}: let
  masterIp = "10.69.0.1";
  masterPort = 6443;
  masterUrl = "http://${kubernetesIp}:${tostring kubernetesPort}";
in {
  services.kubernetes = {
    roles = ["node"];

    masterAddress = masterIp;
    apiserverAddress = masterUrl;

    kubelet = {
      kubeconfig.server = masterUrl;

      extraOpts = "--fail-swap-on=false";
    };
  };
}
