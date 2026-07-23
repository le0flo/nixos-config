{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  generateIni = name: value: {
    inherit value;
    type = "copy";
    permissions = "644";
    generator = (pkgs.formats.ini {}).generate name;
  };
  
  packageDataFiles = dataDir: packages:
    pkgs.lib.pipe packages [
      (builtins.concatMap (pkg:
        pkgs.lib.mapAttrsToList (name: _: {
          name = "${dataDir}/${name}";
          value.source = "${pkg}/share/${dataDir}/${name}";
        })
        (builtins.readDir "${pkg}/share/${dataDir}")))
      builtins.listToAttrs
    ];
in {
  xdg = {
    config.files = {
      "gtk-3.0/settings.ini" = generateIni "settings.ini" {
        Settings = {
          gtk-application-prefer-dark-theme = if style.polarity == "dark" then 1 else 0;

          gtk-cursor-theme-name = style.cursor.name;
          gtk-cursor-theme-size = style.cursor.size;

          gtk-theme-name = style.gtk.theme;
          gtk-icon-theme-name = style.gtk.icons;
        };
      };

      "gtk-4.0/settings.ini" = generateIni "settings.ini" {
        Settings = {
          gtk-application-prefer-dark-theme = if style.polarity == "dark" then 1 else 0;

          gtk-cursor-theme-name = style.cursor.name;
          gtk-cursor-theme-size = style.cursor.size;

          gtk-theme-name = style.gtk.theme;
          gtk-icon-theme-name = style.gtk.icons;
        };
      };
    };

    data.files = {
      "icons" = {
        type = "directory";
        permissions = "755";
      };

      "icons/default/index.theme" = generateIni "index.theme" {
        "Icon Theme" = {
          Name = "Default";
          Comment = "Default icon theme";
          Inherits = style.gtk.icons;
        };
      };

      "themes" = {
        type = "directory";
        permissions = "755";
      };

      "themes/default/index.theme" = generateIni "index.theme" {
        "X-GNOME-Metatheme" = {
          Name = "Default";
          Comment = "Default GTK theme";
          GtkTheme = style.gtk.theme;
        };
      };
    }
    // packageDataFiles "icons" style.gtk.iconsPackages
    // packageDataFiles "themes" style.gtk.themePackages;
  };
}
