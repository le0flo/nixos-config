{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";

    home-manager.url = "github:nix-community/home-manager?ref=master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    xfce4-hiddenapps-plugin.url = "git+https://codeberg.org/leoflo/xfce4-hiddenapps-plugin?ref=refs/tags/v0.0.1";
    xfce4-hiddenapps-plugin.inputs.nixpkgs.follows = "nixpkgs";

    dbmain-nix.url = "git+https://codeberg.org/leoflo/dbmain-nix?ref=refs/tags/v11.0.2";
    dbmain-nix.inputs.nixpkgs.follows = "nixpkgs";

    obdautodoctor-nix.url = "git+https://codeberg.org/leoflo/obdautodoctor-nix?ref=refs/tags/v5.1.8";
    obdautodoctor-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, home-manager, ...} @ inputs:
  let
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
      modules = [ ./systems/afrodite ];
    };

    nixosConfigurations."odino" = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system; };
      modules = [ ./systems/odino ];
    };

    # Home manager
    homeConfigurations."hermes" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [ ./homes/desktop ];
    };

    homeConfigurations."afrodite" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [ ./homes/server ];
    };

    homeConfigurations."odino" = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      pkgs = pkgs;
      modules = [ ./homes/server ];
    };
  };
}
