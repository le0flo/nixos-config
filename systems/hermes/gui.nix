{pkgs, ...}: {
  imports = [
    ../../components/gui/xfce.nix
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
    x11Support = true;

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
  xfce.enable = true;
  niri.enable = true;
}
