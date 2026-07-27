{pkgs, ...}:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-shares-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    alacritty
    rofi

    swaybg
    swaylock-effects
    swayidle
    mako
    xwayland-satellite

    playerctl
    brightnessctl

    pavucontrol
    ristretto
  ];
}
