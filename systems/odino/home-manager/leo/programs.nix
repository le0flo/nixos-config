{...}: {
  imports = [
    ../../../../components/programs/zsh.nix
    ../../../../components/programs/tmux.nix
    ../../../../components/programs/fastfetch.nix
  ];

  zsh.enable = true;
  tmux.enable = true;
  fastfetch.enable = true;
}
