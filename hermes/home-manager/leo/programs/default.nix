{...}: {
  imports = [
    ./zsh.nix
    ./fastfetch.nix
    ./alacritty.nix
    ./zed.nix
  ];

  zsh.enable = true;
  fastfetch.enable = true;
  alacritty.enable = true;
  zed.enable = true;
}
