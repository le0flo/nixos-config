{customLib, inputs}:

let
  inherit (customLib.config) listDirs;

  inherit (inputs.nixpkgs.lib) genAttrs;
in genAttrs (listDirs ./.) (name: import ./${name})
