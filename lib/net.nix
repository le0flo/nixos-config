{nixpkgs}:

let
  inherit (builtins)
    concatStringsSep
    genList
    head
    readFile;

  inherit (nixpkgs.lib)
    flatten
    last
    splitString
    take
    toInt;

  subnetToMask = subnet: last (splitString "/" subnet);

  subnetToNPrefix = subnet: (toInt (subnetToMask subnet)) / 8;
  subnetToNSuffix = subnet: 4 - (subnetToNPrefix subnet);

  subnetToPrefix = subnet: concatStringsSep "." (take
    (subnetToNPrefix subnet)
    (splitString "." (head (splitString "/" subnet))));
in {
  inherit subnetToMask subnetToPrefix;

  readPubKey = secretsPath: name: readFile "${secretsPath}/wireguard/${name}.pub";

  subnetToGateway = subnet: concatStringsSep "." (flatten [
    (subnetToPrefix subnet)
    (genList (_: "0") ((subnetToNSuffix subnet) - 1))
    "1"
  ]);
}
