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
        file = "${secretsPath}/wireguard/afrodite-home.age";
        mode = "400";
      };

      "wireguard/external" = {
        file = "${secretsPath}/wireguard/afrodite-external.age";
        mode = "400";
      };

      "k3s/token" = {
        file = "${secretsPath}/k3s/token.age";
        mode = "400";
      };
    };
  };
}
