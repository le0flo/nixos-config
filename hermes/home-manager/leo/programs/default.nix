{...}: {
  imports = [
    ./zsh.nix
    ./zed.nix
    ./alacritty.nix
    ./waybar.nix
  ];

  zsh.enable = true;
  zed.enable = true;
  alacritty.enable = true;
  waybar.enable = true;
}
