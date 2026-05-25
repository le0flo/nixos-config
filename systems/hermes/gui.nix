{pkgs, ...}:


let
  style = import ../../gui/style.nix { inherit pkgs; };
in {
  imports = [
    ../../gui/niri.nix
  ];

  environment.systemPackages = style.packages;

  xdg = {
    icons.enable = true;
    autostart.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
