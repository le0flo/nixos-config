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

      "microvms/qbittorrent/password" = {
        file = "${secretsPath}/microvms/qbittorrent.age";
        path = "/etc/qbittorrent/password";
        mode = "444";
        symlink = false;
      };

      "microvms/slskd/environment" = {
        file = "${secretsPath}/microvms/slskd.age";
        path = "/etc/slskd/environment";
        mode = "444";
        symlink = false;
      };

      "wireguard/home" = {
        file = "${secretsPath}/wireguard/odino.age";
        mode = "400";
      };
    };
  };
}
