{pkgs, ...}: {
  # Xfce
  services.xserver = {
    enable = true;

    desktopManager.xfce.enable = true;
  };

  # XDG
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  # File manager
  programs.thunar = {
    enable = true;

    plugins = with pkgs; [
      thunar-media-tags-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    xarchiver
    xfce4-whiskermenu-plugin
    xfce4-docklike-plugin
  ];

  # Excluded
  environment.xfce.excludePackages = with pkgs; [ parole ];
}
