{lib, config, ...}: {
  options.alacritty.enable = lib.mkEnableOption "alacritty config";

  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        window = {
          dimensions = { columns = 110; lines = 30; };
          padding = { x = 0; y = 0; };
          opacity = 1.0;
          blur = false;
        };

        font = {
          size = 12.00;
        };

        colors = {
          primary = {
            background = "#282c34";
            foreground = "#abb2bf";
          };

          normal = {
            black = "#1e2127";
            red = "#e06c75";
            green = "#98c379";
            yellow = "#d19a66";
            blue = "#61afef";
            magenta = "#c678dd";
            cyan = "#56b6c2";
            white = "#abb2bf";
          };

          bright = {
            black = "#5c6370";
            red = "#e06c75";
            green = "#98c379";
            yellow = "#d19a66";
            blue = "#61afef";
            magenta = "#c678dd";
            cyan = "#56b6c2";
            white = "#ffffff";
          };
        };
      };
    };
  };
}
