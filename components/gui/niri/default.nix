{pkgs, ...}: {
  # Niri
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  # XDG
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  # File manager
  programs.thunar = {
    enable = true;

    plugins = with pkgs; [
      thunar-media-tags-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    xarchiver
    xwayland-satellite
    fuzzel
    swaybg
    swaylock
    swayidle
    playerctl
    brightnessctl
    themechanger
    ristretto
    pwvucontrol
  ];
}
