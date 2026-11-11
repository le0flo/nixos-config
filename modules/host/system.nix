{config, hostName, self, ...}:

let
  inherit (config.nixpkgs.hostPlatform) system;
in {
  environment.shellAliases = {
    "host-build" = "sudo nixos-rebuild build --flake ~/nixos-config#host-${hostName}";
    "host-boot" = "sudo nixos-rebuild boot --flake ~/nixos-config#host-${hostName}";
    "host-switch" = "sudo nixos-rebuild switch --flake ~/nixos-config#host-${hostName}";
  };

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
