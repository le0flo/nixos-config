{pkgs, ...}:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./services
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAvs2K5ALiCxqylJ22zpMOXXGAaavoiXvZa1LuTq8Gx leo@hermes"
    ];
  };

  environment.shellAliases = {
    "system-build" = "sudo nixos-rebuild build --flake ~/nixos#afrodite";
    "system-boot" = "sudo nixos-rebuild boot --flake ~/nixos#afrodite";
    "system-update" = "sudo nixos-rebuild switch --flake ~/nixos#afrodite";
    "home-update" = "home-manager switch --flake ~/nixos#afrodite";
  };

  system.stateVersion = "26.05";
}
