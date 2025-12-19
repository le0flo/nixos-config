{pkgs, ...}: {
  imports = [
    ./plasma.nix
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

      config.common.default = [ "kde" "gtk" ];

      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
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
  plasma.enable = true;
  sway.enable = true;
}
