{pkgs, ...}:

{
  imports = [
    ../../gui/niri.nix
  ];

  xdg = {
    icons.enable = true;
    autostart.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
