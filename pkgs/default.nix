{customLib, inputs}:

let
  inherit (customLib.config) listDirs perSystem;

  inherit (inputs.nixpkgs.lib) genAttrs;

  pkgs = system: inputs.nixpkgs.legacyPackages."${system}";
  callPackage = system: (pkgs system).lib.callPackageWith (pkgs system // customPackages system);

  customPackages = system: genAttrs (listDirs ./.) (name: callPackage system ./${name} {});
in perSystem customPackages
