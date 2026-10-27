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
    mangowm
    microvm
    nixos-secrets
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
      secretsEnc = toString nixos-secrets;

      readPubKey = customLib.net.readPubKey (toString nixos-secrets);
    };

    modules = [
      disko.nixosModules.default
      agenix.nixosModules.default
      hjem.nixosModules.default
      mangowm.nixosModules.mango
      microvm.nixosModules.host
      self.nixosModules.host
      ./${x}
    ]
    ++ (optional (pathExists ./password.nix) ./password.nix);
  };
}) (listDirs ./.))
