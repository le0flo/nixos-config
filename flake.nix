
{
  description = "My NixOS fleet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gnustep-nix = {
      url = "git+https://codeberg.org/leoflo/gnustep-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    systemConfig = dir: inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        dir
        inputs.hjem.nixosModules.default
      ];
    };
  in {
    nixosConfigurations = {
      "afrodite" = systemConfig ./systems/afrodite;
      "hermes" = systemConfig ./systems/hermes;
      "odino" = systemConfig ./systems/odino;
    };
  };
}
