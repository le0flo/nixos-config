{customLib, inputs}:

let
  inherit (customLib.config) perSystem;

  customPackages = system: inputs.self.packages."${system}";
in perSystem (system: final: prev: customPackages system)
