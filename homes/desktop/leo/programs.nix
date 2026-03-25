{...}: {
  imports = [
    ../../../components/programs/keepassxc.nix
    ../../../components/programs/alacritty.nix
    ../../../components/programs/zed.nix

    ../../../components/programs/zsh.nix
    ../../../components/programs/tmux.nix
    ../../../components/programs/fastfetch.nix
    ../../../components/programs/fuzzel.nix
  ];

  # Custom modules
  keepassxc.enable = false;
  alacritty.enable = true;
  zed.enable = true;

  zsh.enable = true;
  tmux.enable = true;
  fastfetch.enable = true;
  fuzzel.enable = true;
}
