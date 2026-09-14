{customLib, inputs}:

let
  inherit (builtins) listToAttrs;

  inherit (customLib.config) listDirs systems;

  inherit (inputs) agenix disko hjem microvm nixpkgs self;

  inherit (nixpkgs.lib)
    flatten
    nixosSystem;
in listToAttrs (flatten (map (x: (map (y: {
  name = "microvm-${x}-${y}";
  value = nixosSystem {
    specialArgs = {
      inherit customLib;
      serviceName = x;
    };

    modules = [
      microvm.nixosModules.microvm
      self.nixosModules.sirah
      ./template.nix
      ./${x}
    ];
  };
}) systems)) (listDirs ./.)))
