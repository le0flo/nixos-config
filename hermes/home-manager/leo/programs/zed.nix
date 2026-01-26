{lib, config, ...}: {
  options.zed.enable = lib.mkEnableOption "zed config";

  config = lib.mkIf config.zed.enable {
    programs.zed-editor = {
      enable = true;

      userSettings = {
        ui_font_size = 18;
        buffer_font_size = 18;

        theme = {
          mode = "system";
          light = "Gruvbox Dark Soft";
          dark = "Gruvbox Dark Soft";
        };

        format_on_save = "off";
        vim_mode = false;

        terminal = {
          shell = {
            program = "zsh";
          };

          cursor_shape = "bar";
        };

        telemetry = {
          metrics = false;
        };
      };
    };
  };
}
