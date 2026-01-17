{lib, config, pkgs, ...}: {
  options.xfce.enable = lib.mkEnableOption "xfce de";

  config = lib.mkIf config.xfce.enable {
    services.xserver = {
      enable = true;

      desktopManager.xfce.enable = true;
    };

    # File manager
    programs.thunar = {
      enable = true;

      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };

    # XDG
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    # Packages
    environment.systemPackages = with pkgs; [
      bluez blueman
      pasystray
      xarchiver

      xfce4-docklike-plugin xfce4-whiskermenu-plugin
    ];

    # Excluded
    environment.xfce.excludePackages = with pkgs; [ parole ];
  };
}
