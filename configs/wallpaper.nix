{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."background/wallpaper".source = style.wallpaper;
}
