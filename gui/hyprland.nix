{pkgs, ...}:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
  ];
}
