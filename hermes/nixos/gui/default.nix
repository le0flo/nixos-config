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
      session_log = ".ly-session.log";
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

  # Portals
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Custom
  plasma.enable = true;
  gnome.enable = false;
  cosmic.enable = false;
  niri.enable = false;
}
