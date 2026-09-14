{nixpkgs}:

let
  inherit (builtins)
    attrNames
    listToAttrs
    readDir;

  inherit (nixpkgs.lib)
    filterAttrs
    hasSuffix
    removeSuffix;

  sections = attrNames (filterAttrs (x: y:
    y == "regular" &&
    hasSuffix ".nix" x &&
    x != "default.nix"
  ) (readDir ./.));
in listToAttrs (map (x: {
  name = removeSuffix ".nix" x;
  value = import ./${x} { inherit nixpkgs; };
}) sections)
