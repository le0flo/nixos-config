{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./services.nix
    ./programs.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users."leo" = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "wheel"
    ];

    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAokSVn78uTLEMp73AkLVA2q6+U+IPtqaeTc/HKGIFsV leo@hermes"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJj3bxerE8ZA75d01rVRS8KOkxftjaPD8vpxwItmxVbM leo@afrodite"
    ];
  };

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#odino";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#odino";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#odino";
    "home-update" = "home-manager switch --flake ~/nixos#odino";
  };

  system.stateVersion = "26.05";
}
