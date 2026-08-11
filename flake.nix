{
  description = "NixOS config";

  outputs = {self, nixpkgs, disko, agenix, hjem, microvm, ...}@inputs: let
    inherit (builtins)
      attrNames
      concatStringsSep
      elemAt
      readDir
      split;

    inherit (nixpkgs.lib)
      drop
      filterAttrs
      flatten
      genAttrs
      nixosSystem;

    configs = folder: attrNames (filterAttrs (x: y: y == "directory") (readDir folder));
    systems = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];

    nameToModule = name: sep: elemAt (flatten (split sep name)) 1;
    nameToSystem = name: sep: concatStringsSep sep (drop 2 (flatten (split sep name)));

    hosts = genAttrs
      (map (x: "host-${x}") (configs ./hosts))
      (name: nixosSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/${nameToModule name "-"}
          self.nixosModules.otis
          disko.nixosModules.default
          agenix.nixosModules.default
          hjem.nixosModules.default
          microvm.nixosModules.host
        ];
      });

    microvms = genAttrs
      (flatten (map (x: map (y: "microvm-${x}-${y}") systems) (configs ./microvms)))
      (name: nixosSystem {
        system = nameToSystem name "-";
        modules = [
          ./microvms/${nameToModule name "-"}
          microvm.nixosModules.microvm
        ];
      });

    modules = genAttrs
      (configs ./modules)
      (name: import ./modules/${name});

    packages = genAttrs systems
      (system: genAttrs
        (configs ./pkgs)
        (name: nixpkgs.legacyPackages."${system}".callPackage ./pkgs/${name} {}));
  in {
    inherit packages;
    
    nixosModules = modules;
    nixosConfigurations = hosts // microvms;
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

    nixos-secrets = {
      url = "git+https://codeberg.org/leoflo/nixos-secrets";
      flake = false;
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    gnustep = {
      url = "git+https://codeberg.org/leoflo/gnustep-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
