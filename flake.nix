{
  description = "NixOS config";

  outputs = {self, nixpkgs, disko, agenix, hjem, microvm, ...}@inputs: let
    lib = nixpkgs.lib;

    configs = folder: builtins.attrNames (lib.filterAttrs (x: y: y == "directory") (builtins.readDir folder));
    systems = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];

    nameToModule = name: sep: lib.elemAt (lib.flatten (lib.split sep name)) 1;
    nameToSystem = name: sep: lib.concatStringsSep sep (lib.drop 2 (lib.flatten (lib.split sep name)));

    hostConfigs = lib.genAttrs
      (builtins.map (x: "host-${x}") (configs ./hosts))
      (name: lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/initialPassword.nix
          ./hosts/${nameToModule name "-"}
          disko.nixosModules.default
          agenix.nixosModules.default
          hjem.nixosModules.default
          microvm.nixosModules.host
        ];
      });

    microvmConfigs = lib.genAttrs
      (lib.flatten (builtins.map (x: builtins.map (y: "microvm-${x}-${y}") systems) (configs ./microvms)))
      (name: lib.nixosSystem {
        system = nameToSystem name "-";
        modules = [
          ./microvms/${nameToModule name "-"}
          microvm.nixosModules.microvm
        ];
      });
  in {
    nixosConfigurations = hostConfigs // microvmConfigs;
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
