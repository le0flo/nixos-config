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

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    fuzzel
    swaybg
    swaylock-effects
    swayidle
    mako
    playerctl
    brightnessctl
    pwvucontrol
    nautilus
    loupe
  ];
}
