{pkgs, ...}: {
  imports = [
    ../../components/gui/niri
  ];

  # Graphics
  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [ intel-media-driver ];
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

  # X11
  services.xserver = {
    enable = false;

    xkb = {
      layout = "it";
      variant = "";
    };
  };

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # Custom modules
  niri.enable = true;
}
