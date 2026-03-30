{pkgs, ...}: {
  # KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # XDG
  xdg.portal.extraPortals = with pkgs.kdePackages; [ xdg-desktop-portal-kde ];

  # Packages
  environment.systemPackages = with pkgs.kdePackages; [
    kate
    filelight
    flatpak-kcm
  ];

  # Excluded
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    discover
  ];
}
