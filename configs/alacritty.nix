{pkgs, ...}:

{
  xdg.config.files."alacritty/alacritty.toml" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.toml {}).generate "alacritty.toml";
    value = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };

        opacity = 1.0;
        blur = false;
      };

      env = {
        TERM = "xterm-256color";
        WINIT_X11_SCALE_FACTOR = "1.0";
      };

      font = {
        size = 18.00;

        normal = {
          family = "ComicShannsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "ComicShannsMono Nerd Font Mono";
          style = "Bold";
        };
      };
    };
  };
}
