{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./services
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAvs2K5ALiCxqylJ22zpMOXXGAaavoiXvZa1LuTq8Gx leo@hermes"
    ];
  };

  # Shell
  programs.bash = {
    enable = true;
    vteIntegration = true;

    promptInit = ''
      export PS1='\e[1m\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 6)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\$ '
    '';

    shellAliases = {
      l = "ls -lh";
      ll = "ls -lah";

      ssh = "TERM=xterm-256color ssh";

      update-boot = "sudo nixos-rebuild boot --flake ~/nixos#afrodite";
      update-system = "sudo nixos-rebuild switch --flake ~/nixos#afrodite";
      update-home = "home-manager switch --flake ~/nixos#afrodite";
    };
  };

  # Version
  system.stateVersion = "26.05";
}
