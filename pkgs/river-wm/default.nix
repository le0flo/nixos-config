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
    makeScope
    removeSuffix;

  river-wm-packages = self: genAttrs (map
    (x: removeSuffix ".nix" x)
    (filter (x: x != "default.nix") (attrNames (readDir ./.))))
    (name: self.callPackage ./${name}.nix {});
in makeScope pkgs.newScope (self: river-wm-packages self)
