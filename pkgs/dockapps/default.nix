{
  lib,
  pkgs,
  fetchgit,
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

  dockapps-packages = self: genAttrs (map
    (x: removeSuffix ".nix" x)
    (filter (x: x != "package.nix") (attrNames (readDir ./.))))
    (name: self.callPackage ./${name}.nix {});
in makeScope pkgs.newScope (self: {
  dockapps-sources = {
    pname = "dockapps-sources";
    version = "2025-1-1";

    src = fetchgit {
      url = "https://repo.or.cz/dockapps.git";
      rev = "refs/tags/wmCalClock-1.26";
      hash = "sha256-pVyyvYZj9ANUMqXJe2Ky4otgV7wsfLcnWNCgaJXL578=";
    };
  };
}
// dockapps-packages self)
