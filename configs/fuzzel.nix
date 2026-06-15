{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."fuzzel/fuzzel.ini" = {
    type = "copy";
    permissions = "664";

    generator = (pkgs.formats.ini {}).generate "fuzzel.ini";
    value = {
      main = {
        width = 30;
        lines = 10;

        prompt = "search: ";
        icons-enabled = false;
        inner-pad = 10;

        terminal = "${pkgs.foot}/bin/foot -e";
        layer = "overlay";
      };

      border = {
        width = 2;
        radius = 0;
      };

      colors = {
        border = "${style.colors.border}ff";
        background = "${style.colors.background}ff";
        text = "${style.colors.text}ff";

        prompt = "${style.colors.primary}ff";
        input = "${style.colors.secondary}ff";

        selection = "${style.colors.text}ff";
        selection-text = "${style.colors.background}ff";

        match = "${style.colors.primary}ff";
        selection-match = "${style.colors.primary}ff";
      };
    };
  };
}
