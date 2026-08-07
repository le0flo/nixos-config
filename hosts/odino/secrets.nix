{inputs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
in {
  age = {
    identityPaths = [
      "/mnt/trasferimenti/master"
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets = {
      "wireguard/home" = {
        file = "${secretsPath}/wireguard/odino.age";
        mode = "400";
      };

      "k3s/common" = {
        file = "${secretsPath}/k3s/common.age";
        mode = "400";
      };
    };
  };
}
