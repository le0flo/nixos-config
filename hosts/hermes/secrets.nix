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
      "wireguard/home" = {
        file = "${secretsPath}/wireguard/hermes.age";
        mode = "400";
      };
    };
  };
}
