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

      plugins = with pkgs; [
        thunar-media-tags-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };
  };

  # XDG
  xdg.portal = {
    config."niri" = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

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
    xarchiver
    pavucontrol
  ];
}
