{config, lib, pkgs, ...}:

let
  inherit (builtins) attrNames;

  inherit (lib) mkMerge;
in {
  imports = [
    ./archive.nix
    ./devices.nix
    ./dev.nix
    ./fun.nix
    ./internet.nix
    ./media.nix
    ./office.nix
    ./secrets.nix
    ./shell.nix
  ];

  config = let
    forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);
  in mkMerge [
    {
      environment.systemPackages = with pkgs; [
        nano
        tmux
        htop
        file
        tree
        psmisc
      ];

      programs = {
        nix-ld.enable = true;

        appimage = {
          enable = true;
          binfmt = true;
        };
      };
    }
  ]
  ++ forEachUser {
    xdg.config.files."tmux/tmux.conf" = {
      type = "copy";
      permissions = "644";

      text = ''
        set -g mouse on
        set -g base-index 1
        setw -g pane-base-index 1
        setw -g clock-mode-style 24
      '';
    };
  };
}
