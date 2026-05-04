{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./services.nix
    ./programs.nix
  ];

  # Experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Users
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAokSVn78uTLEMp73AkLVA2q6+U+IPtqaeTc/HKGIFsV leo@hermes"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJj3bxerE8ZA75d01rVRS8KOkxftjaPD8vpxwItmxVbM leo@afrodite"
    ];
  };

  # Shell
  environment.shellAliases = {
    update-build = "sudo nixos-rebuild build --flake ~/nixos#odino";
    update-boot = "sudo nixos-rebuild boot --flake ~/nixos#odino";
    update-system = "sudo nixos-rebuild switch --flake ~/nixos#odino";
    update-home = "home-manager switch --flake ~/nixos#odino";
  };

  # Version
  system.stateVersion = "26.05";
}
