{lib, config, pkgs, ...}: {
  options.plasma.enable = lib.mkEnableOption "kde plasma";

  config = lib.mkIf config.plasma.enable {
    services.desktopManager.plasma6.enable = true;

    # Packages
    environment.systemPackages = with pkgs.kdePackages; [
      kate filelight

      flatpak-kcm
    ];

    # Excluded
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      elisa okular discover
    ];
  };
}
