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
    system = y;

    specialArgs = {
      inherit customLib;
      hostName = x;
    };

    modules = [
      microvm.nixosModules.microvm
      self.nixosModules.sirah
      ./${x}
    ];
  };
}) systems)) (listDirs ./.)))
