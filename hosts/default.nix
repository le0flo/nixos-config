{customLib, inputs}:

let
  inherit (builtins)
    listToAttrs
    pathExists;

  inherit (customLib.config) listDirs;

  inherit (inputs)
    agenix
    disko
    hjem
    microvm
    nixpkgs
    self;

  inherit (nixpkgs.lib)
    nixosSystem
    optional;
in listToAttrs (map (x: {
  name = "host-${x}";
  value = nixosSystem {
    specialArgs = {
      inherit customLib inputs self;
      hostName = x;
    };

    modules = [
      disko.nixosModules.default
      agenix.nixosModules.default
      hjem.nixosModules.default
      microvm.nixosModules.host
      self.nixosModules.otis
      ./${x}
    ]
    ++ (optional (pathExists ./password.nix) ./password.nix);
  };
}) (listDirs ./.))
