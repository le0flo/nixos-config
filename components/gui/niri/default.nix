{pkgs, ...}: {
  # Niri
  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };

    dconf.enable = true;

    thunar = {
      enable = true;

      plugins = with pkgs; [ thunar-volman ];
    };
  };

  # XDG
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  # Packages
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    fuzzel
    swaybg
    swaylock
    swayidle
    playerctl
    brightnessctl
    ristretto
    pavucontrol
    mako
  ];
}
