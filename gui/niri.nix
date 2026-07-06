{pkgs, ...}:

{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal.configPackages = with pkgs; [ niri ];

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
    foot
    wl-clipboard
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
