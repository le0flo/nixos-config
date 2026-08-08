{config, inputs, lib, ...}:

let
  secretsPath = toString inputs.nixos-secrets;

  readKey = path: lib.trim (builtins.readFile path);
in {
  publicDomain = "leoflo.net";
  publicSubdomains = [ "files" ];

  privateDomain = "home.arpa";
  privateSubdomains = [
    "files"
    "music"
    "images"
    "papers"
    "cinema"
    "torrent"
    "bt.sharing"
    "slsk.sharing"
  ];

  networks = {
    "home" = {
      primary = true;
      prefix = "10.69.0";
      port = 51820;
      privateKeyFile = "${config.age.secretsDir}/wireguard/home";
      publicKey = readKey "${secretsPath}/wireguard/afrodite-home.pub";
    };

    "external" = {
      prefix = "10.96.0";
      port = 51821;
      privateKeyFile = "${config.age.secretsDir}/wireguard/external";
      publicKey = readKey "${secretsPath}/wireguard/afrodite-external.pub";
    };
  };
}
