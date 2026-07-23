{lib, pkgs, ...}:

{
  programs.mango.enable = true;

  xdg.portal = {
    config."mango".default = lib.mkDefault [
      "gtk"
      "wlr"
    ];

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];

    wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "dmenu";
        chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d";
      };
    };
  };
  
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
