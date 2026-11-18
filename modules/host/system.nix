{config, hostName, self, ...}:

let
  inherit (config.nixpkgs.hostPlatform) system;
in {
  nixpkgs.overlays = [ self.overlays."${system}" ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [ "root" "@wheel" ];
  };

  system.stateVersion = "26.05";
}
