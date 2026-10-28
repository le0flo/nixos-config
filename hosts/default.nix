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
    nixos-secrets-host
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
      secretsEnc = toString nixos-secrets-host;

      readPubKey = customLib.net.readPubKey (toString nixos-secrets-host);
    };

    modules = [
      disko.nixosModules.default
      agenix.nixosModules.default
      hjem.nixosModules.default
      self.nixosModules.host
      ./${x}
    ]
    ++ (optional (pathExists ./password.nix) ./password.nix);
  };
}) (listDirs ./.))
