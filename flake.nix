{
  description = "My NixOS fleet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    systemConfig = arch: dir: inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs arch; };
      modules = [
        dir
        inputs.hjem.nixosModules.default
      ];
    };
  in {
    nixosConfigurations = {
      "afrodite" = systemConfig "x86_64-linux" ./systems/afrodite;
      "hermes" = systemConfig "x86_64-linux" ./systems/hermes;
      "odino" = systemConfig "x86_64-linux" ./systems/odino;
    };
  };
}
