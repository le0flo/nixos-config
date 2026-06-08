{pkgs, ...}:

let
  style = import ../../gui/style.nix { inherit pkgs; };
in {
  environment.systemPackages = [
    style.qt.stylePackage
    style.qt.iconsPackage
  ]
  ++ style.qt.extraPackages
  ++ style.gtk.iconsPackages
  ++ style.gtk.themePackages;
}
