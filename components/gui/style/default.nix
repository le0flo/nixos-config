{pkgs, ...}:

{
  imports = [
    ./fonts.nix
    ./themes.nix
    ./wallpaper.nix
  ];

  stylix = {
    enable = true;
    autoEnable = true;
  };
}
