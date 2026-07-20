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
      thunar-shares-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    fuzzel
    foot
    swaybg
    swaylock-effects
    swayidle
    mako
    playerctl
    brightnessctl
    pavucontrol
    ristretto
  ];
}
