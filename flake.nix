{
  description = "NixOS config";

  outputs = {self, nixpkgs, disko, agenix, hjem, microvm, ...}@inputs: let
    inherit (builtins)
      attrNames
      concatStringsSep
      elemAt
      listToAttrs
      readDir
      split;

    inherit (nixpkgs.lib)
      drop
      filterAttrs
      flatten
      genAttrs
      nixosSystem
      toSentenceCase;

    systems = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];

    configs = folder: attrNames (filterAttrs (x: y: y == "directory") (readDir folder));
    perSystem = genAttrs systems;
    callPackage = system: (pkgs system).lib.callPackageWith (pkgs system // customPkgs system);
    pkgs = system: nixpkgs.legacyPackages.${system};

    customPkgs = system: genAttrs (configs ./pkgs) (name: callPackage system ./pkgs/${name} {});
    customLibs = genAttrs (configs ./libs) (name: import ./libs/${name} { inherit nixpkgs; });

    modules = genAttrs
      (configs ./modules)
      (name: import ./modules/${name});

    hosts = listToAttrs (map (x: {
      name = "host-${x}";
      value = nixosSystem {
        specialArgs = {
          inherit customLibs inputs self;
          hostName = x;
        };

        modules = [
          disko.nixosModules.default
          agenix.nixosModules.default
          hjem.nixosModules.default
          microvm.nixosModules.host
          ./hosts/template.nix
          ./hosts/${x}
        ] ++ (map
          (x: self.nixosModules."${x}")
          (attrNames self.nixosModules));
      };
    }) (configs ./hosts));

    microvms = listToAttrs (flatten (map (x: map (y: {
      name = "microvm-${x}-${y}";
      value = nixosSystem {
        system = y;

        specialArgs = { serviceName = x; };

        modules = [
          microvm.nixosModules.microvm
          ./microvms/template.nix
          ./microvms/${x}
        ];
      };
    }) systems) (configs ./microvms)));
  in {
    nixosModules = modules;
    nixosConfigurations = hosts // microvms;
    packages = perSystem customPkgs;
    overlays = perSystem (system: final: prev: customPkgs system);
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-secrets = {
      url = "git+https://codeberg.org/leoflo/nixos-secrets";
      flake = false;
    };
  };
}
