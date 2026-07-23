{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."qt6ct/qt6ct.conf" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.ini {}).generate "qt6ct.conf";
    value = {
      Appearance = {
        style = style.qt.style;
        icon_theme = style.qt.icons;
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
}
