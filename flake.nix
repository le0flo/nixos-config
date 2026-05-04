{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";

    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, home-manager, disko, stylix, agenix, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # NixOS
    nixosConfigurations."hermes" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };
      modules = [ ./systems/hermes ];
    };

    nixosConfigurations."afrodite" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };
      modules = [
        ./systems/afrodite
        disko.nixosModules.disko
        agenix.nixosModules.default
      ];
    };

    nixosConfigurations."odino" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };
      modules = [ ./systems/odino ];
    };

    # Home manager
    homeConfigurations."hermes" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [
        ./systems/hermes/home.nix
        stylix.homeModules.stylix
      ];
    };

    homeConfigurations."afrodite" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [ ./systems/afrodite/home.nix ];
    };

    homeConfigurations."odino" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [ ./systems/odino/home.nix ];
    };
  };
}
