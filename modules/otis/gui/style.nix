{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatMap
    listToAttrs
    readDir;

  inherit (config.otis) gui;

  inherit (customLibs.otis.hjem)
    configDir
    configFmt;

  inherit (customLibs.otis.opts)
    mkEnumOption
    mkIntOption
    mkStrOption
    mkPkgsOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = gui.style;
  
  mkColorOption = name: default: mkStrOption "Color for the ${name}" default;
  configFmtIni = configFmt pkgs.formats.ini;
  packageLinks = dir: pkgs: (listToAttrs (concatMap (x: map (y: {
    name = "${dir}/${y}";
    value.source = "${x}/share/${dir}/${y}";
  }) (attrNames (readDir "${x}/share/${dir}"))) pkgs));
in {
  options.otis.gui.style = {
    polarity = mkEnumOption [ "light" "dark" ] "Whether you want dark or light theme" "dark";

    wallpaper = mkStrOption
      "Name of the default wallpaper (choose only from the ones inside of the wallpapers package)"
      "road.png";

    colors = {
      border = mkColorOption "border" "#adc178";
      background = mkColorOption "background" "#3d3d3d";
      text = mkColorOption "text" "#fefae0";
      primary = mkColorOption "primary accent" "#adc178";
      secondary = mkColorOption "secondary accent" "#dde5b6";
    };

    cursor = {
      name = mkStrOption "Default cursor theme name" "Adwaita";
      size = mkIntOption "Default cursor size" 20;
      packages = mkPkgsOption "Cursor theme packages" [];
    };

    icons = {
      name = mkStrOption "Default icon pack name" "elementary-xfce-dark";
      packages = mkPkgsOption "Icon pack packages" (with pkgs; [
        adwaita-icon-theme
        elementary-xfce-icon-theme
      ]);
    };

    gtk = {
      name = mkStrOption "Default gtk theme name" "Adwaita";
      packages = mkPkgsOption "Gtk theme packages" [];
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
      qt6Packages.qt6ct
      wallpapers
    ]
    ++ cfg.cursor.packages
    ++ cfg.icons.packages
    ++ cfg.gtk.packages;

    otis.hjem = [{
      xdg = {
        config.files = {
          "gtk-3.0/settings.ini" = configFmtIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if cfg.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = cfg.cursor.name;
              gtk-cursor-theme-size = cfg.cursor.size;

              gtk-theme-name = cfg.gtk.name;
              gtk-icon-theme-name = cfg.icons.name;
            };
          };

          "gtk-4.0/settings.ini" = configFmtIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if cfg.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = cfg.cursor.name;
              gtk-cursor-theme-size = cfg.cursor.size;

              gtk-theme-name = cfg.gtk.name;
              gtk-icon-theme-name = cfg.icons.name;
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
              general = "\"DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0\"";
              fixed = "\"DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0\"";
            };
          };
        };

        data.files = {
          "icons" = configDir;
          "themes" = configDir;
          "wallpapers" = configDir;

          "wallpapers/default" = {
            type = "symlink";
            source = "${pkgs.wallpapers}/share/wallpapers/${cfg.wallpaper}";
          };
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
