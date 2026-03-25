{lib, config, pkgs, ...}: {
  options.niri.enable = lib.mkEnableOption "Niri WM";

  config = lib.mkIf config.niri.enable {
    programs.niri = {
      enable = true;
      useNautilus = false;
    };

    # XDG
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    # Packages
    environment.systemPackages = with pkgs; [
      fuzzel
      wbg
      eww
      xwayland-satellite
      playerctl
      brightnessctl
    ];
  };
}
