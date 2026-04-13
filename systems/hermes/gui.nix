{pkgs, ...}: {
  imports = [
    ../../components/gui/niri
  ];

  # XDG
  xdg = {
    icons.enable = true;
    autostart.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
