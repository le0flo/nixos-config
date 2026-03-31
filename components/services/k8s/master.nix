{...}: let
  masterIp = "10.69.0.1";
  masterPort = 6443;
  masterName = "home.arpa";
in {
  services.kubernetes = {
    roles = ["master" "node"];
    easyCerts = true;

    masterAddress = masterName;
    apiserverAddress = "https://${masterName}:${builtins.toString masterPort}";

    apiserver = {
      advertiseAddress = masterIp;
      securePort = masterPort;
    };

    kubelet.extraOpts = "--fail-swap-on=false";

    pki.cfsslAPIExtraSANs = [
      "localhost"
      masterName
      "127.0.0.1"
      masterIp
    ];
  };
}
