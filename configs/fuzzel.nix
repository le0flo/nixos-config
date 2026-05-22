{pkgs, ...}:

let
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
      background = "505050ff";
      text = "fefae0ff";
      border = "adc178ff";

      prompt = "adc178ff";
      input = "dde5b6ff";

      selection = "fefae0ff";
      selection-text = "505050ff";

      match = "adc178ff";
      selection-match = "adc178ff";
    };
  };
in {
  xdg.config.files."fuzzel/fuzzel.ini".source = ini.generate "fuzzel.ini" settings;
}
