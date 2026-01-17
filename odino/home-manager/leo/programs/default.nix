{...}: {
  imports = [
    ./zsh.nix
    ./fastfetch.nix
  ];

  zsh.enable = true;
  fastfetch.enable = true;
}
