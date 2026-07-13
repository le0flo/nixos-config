{
  description = "My NixOS fleet";

  outputs = inputs: let
    systemConfig = dir: inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        dir
        inputs.hjem.nixosModules.default
        inputs.microvm.nixosModules.host
        inputs.disko.nixosModules.default
      ];
    };

    microvmConfig = dir: inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        dir
        inputs.microvm.nixosModules.microvm
      ];
    };
  in {
    nixosConfigurations = {
      "afrodite" = systemConfig ./systems/afrodite;
      "hermes" = systemConfig ./systems/hermes;
      "odino" = systemConfig ./systems/odino;
      "thor" = systemConfig ./systems/thor;

      "navidrome" = microvmConfig ./microvms/navidrome;
      "immich" = microvmConfig ./microvms/immich;
      "paperless" = microvmConfig ./microvms/paperless;
      "jellyfin" = microvmConfig ./microvms/jellyfin;
      "sharing" = microvmConfig ./microvms/sharing;
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko/latest";
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

    gnustep-nix = {
      url = "git+https://codeberg.org/leoflo/gnustep-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
