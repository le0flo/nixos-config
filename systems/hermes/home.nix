{pkgs, ...}: {
  imports = [
    ../../components/gui/style
    ../../components/gui/niri/config.nix

    ../../components/programs/configs/alacritty.nix
    ../../components/programs/configs/fastfetch.nix
    ../../components/programs/configs/fuzzel.nix
    ../../components/programs/configs/git.nix
    ../../components/programs/configs/swaylock.nix
    ../../components/programs/configs/tmux.nix
    ../../components/programs/configs/zed.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";

    stateVersion = "26.05";
  };
}
