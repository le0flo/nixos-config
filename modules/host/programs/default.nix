{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.hjem) configText;

  inherit (lib)
    mkMerge
    mkIf;
in {
  imports = [
    ./dev

    ./archive.nix
    ./devices.nix
    ./fun.nix
    ./games.nix
    ./internet.nix
    ./media.nix
    ./office.nix
    ./secrets.nix
    ./shell.nix
  ];

  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        file
        htop
        nano
        psmisc
        tmux
        tree
        vis
      ];

      hostConfig.hjem = [{
        xdg.config.files."tmux/tmux.conf" = configText ''
        set -g mouse on
        set -g base-index 1
        setw -g pane-base-index 1
        setw -g clock-mode-style 24
        '';
      }];

      programs = {
        nix-ld.enable = true;

        appimage = {
          enable = true;
          binfmt = true;
        };
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        libnotify
        wl-clipboard
        xclip
        xfce4-terminal
      ];

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-shares-plugin
          thunar-volman
        ];
      };

      services.tumbler.enable = true;
    })
  ];
}
