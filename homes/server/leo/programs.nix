{...}: {
  imports = [
    ../../../components/programs/zsh.nix
    ../../../components/programs/tmux.nix
    ../../../components/programs/fastfetch.nix
  ];

  # Custom modules
  zsh.enable = true;
  tmux.enable = true;
  fastfetch.enable = true;
}
