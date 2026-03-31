{...}: let
  masterIp = "10.69.0.1";
  masterPort = 6443;
in {
  services.kubernetes = {
    roles = ["master" "node"];

    masterAddress = masterIp;
    apiserverAddress = "http://${masterIp}:${builtins.toString masterPort}";

    apiserver = {
      advertiseAddress = masterIp;
      securePort = masterPort;
    };

    kubelet.extraOpts = "--fail-swap-on=false";
  };
}
