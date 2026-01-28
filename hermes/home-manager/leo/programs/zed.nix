{lib, config, ...}: {
  options.zed.enable = lib.mkEnableOption "zed config";

  config = lib.mkIf config.zed.enable {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        telemetry = {
          metrics = false;
        };

        ui_font_size = 18;
        buffer_font_size = 18;
        vim_mode = false;

        format_on_save = "off";
        hard_tabs = false;
        tab_size = 2;

        theme = {
          mode = "system";
          light = "Gruvbox Dark Soft";
          dark = "Gruvbox Dark Soft";
        };

        terminal = {
          shell = {
            program = "zsh";
          };

          cursor_shape = "bar";
        };
      };
    };
  };
}
