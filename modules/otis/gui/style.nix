{config, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    concatMap
    listToAttrs
    readDir;
  
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.gui.style =
    let
      mkStrOption = description: default: mkOption {
        inherit description default;
        type = types.str;
      };

      mkColorOption = name: default: mkStrOption "Color for the ${name}" default;

      mkPkgsOption = description: default: {
        inherit description default;
        type = with types; listOf package;
      };
    in {
      polarity = mkOption {
        type = types.enum [ "light" "dark" ];
        description = "Whether you want dark or light theme";
        default = "dark";
      };

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

        size = mkOption {
          type = types.int;
          description = "Default cursor size";
          default = 20;
        };

        packages = mkPkgsOption "Cursor theme packages" [];
      };

      icons = {
        name = mkStrOption "Default icon pack name" "elementary-xfce-dark";

        packages = mkPkgsOption
          "Icon pack packages"
          (with pkgs; [
            adwaita-icon-theme
            elementary-xfce-icon-theme
          ]);
      };

      gtk = {
        name = mkStrOption
          "Default gtk theme name"
          "Adwaita";

        packages = mkPkgsOption "Gtk theme packages" [];
      };

      qt = {
        style = mkStrOption "Qt widgets style" "Fusion";
        colorScheme = mkStrOption "Qt applications color scheme" "darker";
        dialogs = mkStrOption "Which file picker implementation to use" "xdgdesktopportal";
      };
    };

  config =
    let
      gui = config.otis.gui;
      style = gui.style;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);

      generateIni = name: value: {
        inherit value;

        type = "copy";
        permissions = "644";
        generator = (pkgs.formats.ini {}).generate name;
      };

      packageLinks = directory: packages: (listToAttrs
        (concatMap
          (x: map
            (y: {
              name = "${directory}/${y}";
              value.source = "${x}/share/${directory}/${y}";
            })
            (readDir "${x}/share/${directory}"))
          packages));
    in mkIf gui.enable (mkMerge [
      {
        environment.systemPackages =
          [ pkgs.qt6Packages.qt6ct ]
          ++ style.cursor.packages
          ++ style.icons.packages
          ++ style.gtk.packages;
      }
    ]
    ++ forEachUser {
      xdg = {
        config.files = {
          "gtk-3.0/settings.ini" = generateIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if style.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = style.cursor.name;
              gtk-cursor-theme-size = style.cursor.size;

              gtk-theme-name = style.gtk.name;
              gtk-icon-theme-name = style.icons.name;
            };
          };

          "gtk-4.0/settings.ini" = generateIni "settings.ini" {
            Settings = {
              gtk-application-prefer-dark-theme = if style.polarity == "dark" then 1 else 0;

              gtk-cursor-theme-name = style.cursor.name;
              gtk-cursor-theme-size = style.cursor.size;

              gtk-theme-name = style.gtk.name;
              gtk-icon-theme-name = style.icons.name;
            };
          };

          "qt6ct/qt6ct.conf" = generateIni "qt6ct.conf" {
            Appearance = {
              style = style.qt.style;
              icon_theme = style.icons.name;
              color_scheme_path = "${pkgs.qt6Packages.qt6ct}/share/qt6ct/colors/${style.qt.colorScheme}.conf";
              custom_palette = true;
              standard_dialogs = style.qt.dialogs;
            };

            Fonts = {
              general = "\"DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0\"";
              fixed = "\"DejaVu Sans,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Book,0,0\"";
            };
          };
        };

        data.files = {
          "icons" = {
            type = "directory";
            permissions = "755";
          };

          "themes" = {
            type = "directory";
            permissions = "755";
          };
        }
        // packageLinks "icons" style.cursor.packages
        // packageLinks "icons" style.icons.packages
        // packageLinks "themes" style.gtk.packages;

        # TODO: mancano gli sfondi
      };
    });
}
