{inputs, lib, config, pkgs, ...}:
let
  thunar-archive-plugin-with-xarchiver = pkgs.thunar-archive-plugin.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${pkgs.xarchiver}/libexec/thunar-archive-plugin/xarchiver.tap \
         $out/libexec/thunar-archive-plugin/
    '';
  });
in {
  options.xfce.enable = lib.mkEnableOption "Xfce DE";

  config = lib.mkIf config.xfce.enable {
    services.xserver = {
      enable = true;

      desktopManager.xfce.enable = true;
    };

    # File manager
    programs.thunar = {
      enable = true;

      plugins = with pkgs; [
        thunar-archive-plugin-with-xarchiver
        thunar-media-tags-plugin
        thunar-vcs-plugin
        thunar-volman
      ];
    };

    # XDG
    xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

    # Packages
    environment.systemPackages = with pkgs; [
      xarchiver
      xfce4-whiskermenu-plugin
      xfce4-docklike-plugin

      inputs.xfce4-hiddenapps-plugin.packages.x86_64-linux.default
    ];

    # Excluded
    environment.xfce.excludePackages = with pkgs; [ parole ];
  };
}
