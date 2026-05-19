{pkgs, ...}:

{
  imports = [
    ../../components/gui/niri
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
