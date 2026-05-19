{pkgs, ...}:

{
  services.desktopManager.plasma6.enable = true;

  xdg.portal.extraPortals = with pkgs.kdePackages; [ xdg-desktop-portal-kde ];

  environment.systemPackages = with pkgs.kdePackages; [
    kate
    filelight
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
    discover
  ];
}
