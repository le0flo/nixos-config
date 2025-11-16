{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./plasma.nix
    ./cosmic.nix
    ./niri.nix
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

  # Custom
  plasma.enable = true;
  gnome.enable = false;
  cosmic.enable = false;
  niri.enable = false;
}
