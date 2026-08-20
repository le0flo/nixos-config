{
  lib,
  pkgs,
  fetchgit,
}:

lib.makeScope pkgs.newScope (self: let
  dockapps-packages = lib.genAttrs
    (builtins.map
      (x: lib.removeSuffix ".nix" x)
      (builtins.filter
        (x: x != "package.nix")
        (builtins.attrNames (builtins.readDir ./.))))
    (name: self.callPackage ./${name}.nix {});
in {
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
// dockapps-packages)
