{
  description = "NixOS config";

  outputs = inputs: let
    customLib = import ./lib { inherit (inputs) nixpkgs; };
  in {
    packages = import ./pkgs { inherit customLib inputs; };
    overlays = import ./overlays { inherit customLib inputs; };

    nixosModules = import ./modules { inherit customLib inputs; };
    nixosConfigurations = (import ./hosts { inherit customLib inputs; }) // (import ./microvms { inherit customLib inputs; });
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

    hyprland.url = "github:hyprwm/Hyprland/v0.56.0";

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
