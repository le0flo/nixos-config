{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  packageBackgrounds = lib.genAttrs
    (builtins.attrNames (builtins.readDir ../assets/backgrounds))
    (file: {
      source = ../assets/backgrounds/${file};
      target = "backgrounds/${file}";
      type = "copy";
      permissions = "644";
    });
in {
  xdg.data.files = {
    "backgrounds" = {
      type = "directory";
      permissions = "755";
    };

    "backgrounds/default" = {
      source = ../assets/backgrounds/${style.wallpaper};
      type = "symlink";
    };
  }
  // packageBackgrounds;
}
