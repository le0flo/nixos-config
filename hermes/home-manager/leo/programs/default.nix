{...}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./fastfetch.nix
    ./alacritty.nix
    ./zed.nix
  ];

  zsh.enable = true;
  tmux.enable = true;
  fastfetch.enable = true;
  alacritty.enable = true;
  zed.enable = true;
}
