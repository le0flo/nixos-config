{...}: {
  imports = [
    ../../components/gui/niri/config.nix

    ../../components/programs/configs/alacritty.nix
    ../../components/programs/configs/fastfetch.nix
    ../../components/programs/configs/fuzzel.nix
    ../../components/programs/configs/git.nix
    ../../components/programs/configs/gtk.nix
    ../../components/programs/configs/qt.nix
    ../../components/programs/configs/swaylock.nix
    ../../components/programs/configs/tmux.nix
    ../../components/programs/configs/zed.nix
    ../../components/programs/configs/zsh.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  # Version
  home.stateVersion = "26.05";
}
