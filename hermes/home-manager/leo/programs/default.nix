{...}: {
  imports = [
    ./zsh.nix
    ./syncthing.nix
    ./zed.nix
    ./alacritty.nix
    ./waybar.nix
  ];

  zsh.enable = true;
  syncthing.enable = true;
  zed.enable = true;
  alacritty.enable = true;
  waybar.enable = true;
}
