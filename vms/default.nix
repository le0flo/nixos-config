{customLib, inputs}:

let
  inherit (builtins)
    listToAttrs
    pathExists;

  inherit (customLib.config)
    listDirs
    systems;

  inherit (inputs)
    agenix
    disko
    nixos-secrets-vm
    nixpkgs
    self;

  inherit (nixpkgs.lib)
    flatten
    nixosSystem
    optional;
in listToAttrs (flatten (map (x: (map (y: {
  name = "vm-${x}-${y}";
  value = nixosSystem {
    system = y;

    specialArgs = {
      inherit customLib;

      hostName = x;
      secretsEnc = toString nixos-secrets-vm;
    };

    modules = [
      disko.nixosModules.default
      agenix.nixosModules.default
      self.nixosModules.vm
      ./${x}
    ]
    ++ (optional (pathExists ../password.nix) ../password.nix);
  };
}) systems)) (listDirs ./.)))
