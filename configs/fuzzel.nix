{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
  ini = pkgs.formats.ini {};
  settings = {
    main = {
      prompt = "search: ";
      icons-enabled = false;
      inner-pad = 10;

      terminal = "${pkgs.alacritty}/bin/alacritty -e";
      layer = "overlay";
    };

    border = {
      width = 3;
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
in {
  xdg.config.files."fuzzel/fuzzel.ini".source = ini.generate "fuzzel.ini" settings;
}
