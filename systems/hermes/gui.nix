{pkgs, ...}:

{
  imports = [
    ../../gui/fonts.nix
    ../../gui/niri.nix
    ../../gui/windowmaker.nix
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
