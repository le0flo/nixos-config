{
  lib,
  pkgs,
}:

let
  inherit (builtins)
    attrNames
    filter
    readDir;
  
  inherit (lib)
    genAttrs
    makeScope;

  inherit (pkgs) newScope;
in makeScope newScope (self: genAttrs
  (filter (x: x != "default.nix") (attrNames (readDir ./.)))
  (name: self.callPackage ./${name} {}))
