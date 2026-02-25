{...}: {
  imports = [
    ./keepassxc.nix
    ./alacritty.nix
    ./zed.nix

    ./zsh.nix
    ./tmux.nix
    ./fastfetch.nix
  ];

  keepassxc.enable = true;
  alacritty.enable = true;
  zed.enable = true;

  zsh.enable = true;
  tmux.enable = true;
  fastfetch.enable = true;
}
