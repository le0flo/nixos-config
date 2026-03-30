{pkgs, ...}: {
  imports = [
    ../../components/gui/niri
  ];

  # Graphics
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [ intel-media-driver ];
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # X11
  services.xserver = {
    enable = false;

    xkb = {
      layout = "it";
      variant = "";
    };
  };

  # Ly
  services.displayManager.ly = {
    enable = true;
    x11Support = false;

    settings = {
      animation = "gameoflife";
      bigclock = "en";
      session_log = ".ly-session.log";
    };
  };

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
