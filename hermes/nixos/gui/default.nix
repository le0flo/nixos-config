{pkgs, ...}: {
  imports = [
    ./plasma.nix
    ./xfce.nix
    ./sway.nix
  ];

  # Drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
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

  # Custom
  #
  # NOTE: kde and xfce cannot be enabled due to conflicting pinetry package
  plasma.enable = false;
  xfce.enable = true;
  sway.enable = true;
}
