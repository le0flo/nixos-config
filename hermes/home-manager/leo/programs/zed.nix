{lib, config, ...}: {
  options.zed.enable = lib.mkEnableOption "zed config";

  config = lib.mkIf config.zed.enable {
    programs.zed-editor = {
      enable = true;

      extensions = [
        "one-dark-pro"
        "latex"
      ];

      userSettings = {
        format_on_save = "off";
        vim_mode = false;

        ui_font_size = 18;
        buffer_font_size = 18;

        theme = {
          mode = "system";
          light = "One Dark Pro";
          dark = "One Dark Pro";
        };

        telemetry = {
          metrics = false;
        };

        lsp = {
          texlab = {
            settings = {
              texlab = {
                build = {
                  onSave = false;
                  forwardSearchAfter = false;
                };
              };
            };
          };
        };
      };
    };
  };
}
