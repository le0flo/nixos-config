{...}: {
  imports = [
    ./zsh.nix
    ./alacritty.nix
    ./zed.nix
  ];

  zsh.enable = true;
  alacritty.enable = true;
  zed.enable = true;
}
