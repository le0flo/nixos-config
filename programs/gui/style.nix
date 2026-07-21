{pkgs, ...}:

let
  style = import ../../gui/style.nix { inherit pkgs; };
in {
  environment.systemPackages = [ pkgs.qt6Packages.qt6ct ]
  ++ style.gtk.iconsPackages
  ++ style.gtk.themePackages;
}
