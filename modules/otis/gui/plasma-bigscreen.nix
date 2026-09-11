{config, customLibs, lib, pkgs, ...}:

let
  inherit (customLibs.cake.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib) getBin makeSearchPath mkIf;

  cfg = config.otis.gui.plasma-bigscreen;
  kdePackages = with pkgs.kdePackages; [
    breeze
    breeze-icons
    kactivitymanagerd
    kdeconnect-kde
    kwin
    plasma-bigscreen
    plasma-nm
    plasma-pa
    plasma-workspace
    powerdevil
    qqc2-breeze-style
  ];

  sessionScript = pkgs.writeShellScriptBin "plasma-bigscreen-session" ''
  export QML2_IMPORT_PATH="${makeSearchPath "lib/qt-6/qml" kdePackages}:$QML2_IMPORT_PATH"

  export QT_ENABLE_GLYPH_CACHE_WORKAROUND=1
  export QT_FILE_SELECTORS=mediacenter
  export QT_QPA_PLATFORM=wayland
  export QT_QUICK_CONTROLS_MOBILE=true
  export QT_QUICK_CONTROLS_STYLE=org.kde.breeze

  export PLASMA_INTEGRATION_USE_PORTAL=1
  export PLASMA_PLATFORM=mediacenter
  export PLASMA_DEFAULT_SHELL=org.kde.plasma.bigscreen

  export XCURSOR_THEME=breeze_cursors

  export XDG_CONFIG_DIRS="$HOME/.config/plasma-bigscreen:/etc/xdg:$XDG_CONFIG_DIRS"
  export XDG_DATA_DIRS="${makeSearchPath "share" kdePackages}:$XDG_DATA_DIRS"

  QT_QPA_PLATFORM=offscreen \
    ${pkgs.kdePackages.plasma-bigscreen}/bin/plasma-bigscreen-envmanager \
    --apply-settings

  exec ${pkgs.dbus}/bin/dbus-run-session sh -c '
    ${pkgs.kdePackages.kactivitymanagerd}/libexec/kactivitymanagerd start-daemon &
    exec ${config.security.wrapperDir}/kwin_wayland \
      "${pkgs.kdePackages.plasma-workspace}/bin/plasmashell -p org.kde.plasma.bigscreen"
  '
  '';
in {
  options.otis.gui.plasma-bigscreen = {
    enable = mkBoolOption "Plasma Bigscreen graphical session" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-plasma-bigscreen" = "${sessionScript}/bin/plasma-bigscreen-session";
      systemPackages = [ sessionScript ] ++ kdePackages ++ cfg.extraPackages;
    };

    security.wrappers."kwin_wayland" = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_nice+ep";
      source = "${getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
    };

    xdg.portal.configPackages = [ pkgs.kdePackages.plasma-bigscreen ];
  };
}
