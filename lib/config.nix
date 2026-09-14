{nixpkgs}:

let
  inherit (builtins)
    attrNames
    readDir;

  inherit (nixpkgs.lib)
    filterAttrs
    genAttrs;

  systems = [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
  ];
in {
  inherit systems;

  listDirs = folder: attrNames (filterAttrs (_: y: y == "directory") (readDir folder));

  listFiles = folder: attrNames (filterAttrs (_: y: y == "regular") (readDir folder));

  perSystem = f: genAttrs systems (system: f system);
}
