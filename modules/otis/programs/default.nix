{customLibs, pkgs, ...}:

let
  inherit (customLibs.otis.hjem) configText;
in {
  imports = [
    ./archive.nix
    ./devices.nix
    ./dev.nix
    ./fun.nix
    ./games.nix
    ./internet.nix
    ./media.nix
    ./office.nix
    ./secrets.nix
    ./shell.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      nano
      tmux
      htop
      file
      tree
      psmisc
    ];

    otis.hjem = [{
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
  };
}
