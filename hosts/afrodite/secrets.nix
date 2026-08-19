{config, inputs, ...}:

let
  secretsPath = toString inputs.nixos-secrets;
  privateDomain = config.otis.net.dns.domains.private;
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

      "tls/${privateDomain}.key" = {
        file = "${secretsPath}/tls/${privateDomain}.age";
        mode = "444";
      };

      "wireguard/home" = {
        file = "${secretsPath}/wireguard/afrodite-home.age";
        mode = "400";
      };

      "wireguard/external" = {
        file = "${secretsPath}/wireguard/afrodite-external.age";
        mode = "400";
      };
    };
  };
}
