{
  description = "My NixOS fleet";

  outputs = {self, nixpkgs, disko, hjem, microvm, ...}@inputs: let
    systemConfig = dir: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        dir
        disko.nixosModules.default
        hjem.nixosModules.default
        microvm.nixosModules.host
      ];
    };

    microvmConfig = dir: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        dir
        microvm.nixosModules.microvm
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

    xfce-nix = {
      url = "git+https://codeberg.org/leoflo/xfce-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
