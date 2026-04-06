{...}: {
  programs.alacritty = {
    enable = true;

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
  };
}
