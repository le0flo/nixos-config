{lib, config, pkgs, ...}: {
  options.xfce.enable = lib.mkEnableOption "xfce de";

  config = lib.mkIf config.xfce.enable {
    services.xserver = {
      enable = true;

      desktopManager.xfce.enable = true;
    };

    # Packages
    environment.systemPackages = with pkgs; [
      bluez blueman
      pasystray
      xfce.xfce4-docklike-plugin xfce.xfce4-whiskermenu-plugin
      xarchiver
    ];
  };
}
