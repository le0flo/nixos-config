{customLib, inputs}:

let
  inherit (builtins)
    mapAttrs
    readDir;

  inherit (customLib.config) listDirs perSystem;

  inherit (inputs.nixpkgs.lib)
    filterAttrs
    genAttrs;

  pkgs = system: inputs.nixpkgs.legacyPackages."${system}";
  callPackage = system: (pkgs system).lib.callPackageWith (pkgs system // customPackages system);

  customPackages = system: genAttrs (listDirs ./.) (name: callPackage system ./${name} {});
in perSystem customPackages
