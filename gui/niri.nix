{pkgs, ...}:

{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-shares-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    fuzzel
    swaybg
    swaylock-effects
    swayidle
    mako
    playerctl
    brightnessctl
    pavucontrol
    ristretto
    xarchiver
    mousepad
  ];
}
