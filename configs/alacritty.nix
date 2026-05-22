{pkgs, ...}:

let
  toml = pkgs.formats.toml {};
  settings = {
    window = {
      dimensions = {
        columns = 110;
        lines = 30;
      };

      padding = {
        x = 10;
        y = 10;
      };

      opacity = 1.0;
      blur = false;
    };
  };
in {
  xdg.config.files."alacritty/alacritty.toml".source = toml.generate "alacritty.toml" settings;
}
