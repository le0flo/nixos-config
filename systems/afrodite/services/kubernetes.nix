{...}:

let
  address = "10.69.0.1";
  port = 6443;
  domain = "home.arpa";
in {
  services.kubernetes = {
    roles = [
      "master"
      "node"
    ];

    masterAddress = domain;
    apiserverAddress = "http://${domain}:${toString port}";

    apiserver = {
      securePort = port;
      advertiseAddress = address;
    };
  };
}
