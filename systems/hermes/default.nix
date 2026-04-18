{pkgs, ...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./locales.nix

    ./gui.nix
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
      "video"
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

      update-boot = "sudo nixos-rebuild boot --flake ~/nixos#hermes";
      update-system = "sudo nixos-rebuild switch --flake ~/nixos#hermes";
      update-home = "home-manager switch --flake ~/nixos#hermes";
    };
  };

  # Version
  system.stateVersion = "26.05";
}
