{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatMap
    listToAttrs
    readDir;

  inherit (config.hostConfig) gui;

  inherit (customLib.hjem)
    configDir
    configFmt
    configText;

  inherit (customLib.opts)
    mkEnumOption
    mkIntOption
    mkStrOption
    mkPkgsOption;

  inherit (lib) mkIf;

  cfg = gui.style;

  configFmtIni = configFmt pkgs.formats.ini;

  mkColorOption = name: default: mkStrOption "Color for the ${name}" default;
  packageLinks = dir: pkgs: (listToAttrs (concatMap (x: map (y: {
    name = "${dir}/${y}";
    value.source = "${x}/share/${dir}/${y}";
  }) (attrNames (readDir "${x}/share/${dir}"))) pkgs));
in {
  options.hostConfig.gui.style = {
    polarity = mkEnumOption [ "light" "dark" ] "Whether you want dark or light theme" "dark";

    cursor = {
      name = mkStrOption "Default cursor theme name" "Adwaita";
      size = mkIntOption "Default cursor size" 20;
      packages = mkPkgsOption "Cursor theme packages" [];
    };

    icons = {
      name = mkStrOption "Default icon pack name" "elementary-xfce-dark";
      packages = mkPkgsOption "Icon pack packages" (with pkgs; [
        adwaita-icon-theme
        gnome-themes-extra
        hicolor-icon-theme
        elementary-xfce-icon-theme
      ]);
    };

    gtk = {
      name = mkStrOption "Default gtk theme name" "Adwaita";
      packages = mkPkgsOption "Gtk theme packages" (with pkgs; [
        gnome-themes-extra
        greybird
      ]);
    };

    qt = {
      style = mkStrOption "Qt widgets style" "Fusion";
      colorScheme = mkStrOption "Qt applications color scheme" "darker";
      dialogs = mkStrOption "Which file picker implementation to use" "xdgdesktopportal";
    };
  };

  config = mkIf gui.enable {
    environment.systemPackages = with pkgs; [
      dconf
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      wallpapers
    ]
    ++ cfg.cursor.packages
    ++ cfg.icons.packages
    ++ cfg.gtk.packages;

    hostConfig.hjem = [{
      xdg = {
        config.files = {
          "gtk-3.0/settings.ini" = configFmtIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if cfg.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = cfg.cursor.name;
              gtk-cursor-theme-size = cfg.cursor.size;

              gtk-theme-name = cfg.gtk.name;
              gtk-icon-theme-name = cfg.icons.name;
              gtk-dialogs-use-header = false;
            };
          };

          "gtk-3.0/gtk.css" = configText ''
          headerbar.default-decoration {
            margin-bottom: 50px;
            margin-top: -100px;
          }

          window.csd, window.csd decoration { box-shadow: none; }
          '';

          "gtk-4.0/settings.ini" = configFmtIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if cfg.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = cfg.cursor.name;
              gtk-cursor-theme-size = cfg.cursor.size;

              gtk-theme-name = cfg.gtk.name;
              gtk-icon-theme-name = cfg.icons.name;
              gtk-dialogs-use-header = false;
            };
          };

          "gtk-4.0/gtk.css" = configText ''
          headerbar.default-decoration {
            margin-bottom: 50px;
            margin-top: -100px;
          }

          window.csd, window.csd decoration { box-shadow: none; }
          '';

          "qt5ct/qt5ct.conf" = configFmtIni "qt5ct.conf" {
            Appearance = {
              style = cfg.qt.style;
              icon_theme = cfg.icons.name;
              color_scheme_path = "${pkgs.libsForQt5.qt5ct}/share/qt5ct/colors/${cfg.qt.colorScheme}.conf";
              custom_palette = true;
              standard_dialogs = cfg.qt.dialogs;
            };

            Fonts = {
              fixed = "DejaVu Sans Mono,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0";
              general = "DejaVu Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0";
            };
          };

          "qt6ct/qt6ct.conf" = configFmtIni "qt6ct.conf" {
            Appearance = {
              style = cfg.qt.style;
              icon_theme = cfg.icons.name;
              color_scheme_path = "${pkgs.qt6Packages.qt6ct}/share/qt6ct/colors/${cfg.qt.colorScheme}.conf";
              custom_palette = true;
              standard_dialogs = cfg.qt.dialogs;
            };

            Fonts = {
              fixed = "DejaVu Sans Mono,11,-1,5,50,0,0,0,0,0,Book";
              general = "DejaVu Sans,11,-1,5,50,0,0,0,0,0,Book";
            };
          };
        };

        data.files = {
          "icons" = configDir;
          "themes" = configDir;
          "wallpapers" = configDir;
        }
        // packageLinks "icons" cfg.cursor.packages
        // packageLinks "icons" cfg.icons.packages
        // packageLinks "themes" cfg.gtk.packages
        // packageLinks "wallpapers" [ pkgs.wallpapers ];
      };
    }];

    systemd.user.services."dconf-init" = {
      wantedBy = [ "default.target" ];
      path = [ pkgs.dconf ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
      dconf write /org/gnome/desktop/interface/color-scheme "'prefer-${cfg.polarity}'"
      dconf write /org/gnome/desktop/interface/gtk-theme "'${cfg.gtk.name}'"
      dconf write /org/gnome/desktop/interface/icon-theme "'${cfg.icons.name}'"
      '';
    };
  };
}
