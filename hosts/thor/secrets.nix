{inputs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
in {
  age = {
    identityPaths = [
      "/mnt/trasferimenti/ssh/master"
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets = {
      "k3s/token" = {
        file = "${secretsPath}/k3s/token.age";
        mode = "400";
      };

      "microvms/paperless" = {
        file = "${secretsPath}/microvms/paperless.age";
        mode = "444";
      };

      "wireguard/home" = {
        file = "${secretsPath}/wireguard/thor.age";
        mode = "400";
      };
    };
  };
}
