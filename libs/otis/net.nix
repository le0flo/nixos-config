{nixpkgs}:

let
  inherit (builtins)
    concatStringsSep
    head;

  inherit (nixpkgs.lib)
    last
    splitString
    take
    toInt;

  subnetToMask = subnet: last (splitString "/" subnet);
in {
  inherit subnetToMask;

  subnetToPrefix = subnet: concatStringsSep "." (take
    ((toInt (subnetToMask subnet)) / 8)
    (splitString "." (head (splitString "/" subnet))));
}
