{config, inputs, ...}:

let
  inherit (config.services.dovecot2.settings) mail_uid mail_gid;

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

      "mail/dovecot-passwd" = {
        file = "${secretsPath}/mail/dovecot-passwd.age";
        mode = "440";
        owner = "dovecot2";
        group = "dovecot2";
      };

      "tls/${privateDomain}.key" = {
        file = "${secretsPath}/tls/${privateDomain}.age";
        mode = "444";
      };

      "wireguard/external" = {
        file = "${secretsPath}/wireguard/afrodite-external.age";
        mode = "400";
      };

      "wireguard/home" = {
        file = "${secretsPath}/wireguard/afrodite-home.age";
        mode = "400";
      };
    };
  };
}
