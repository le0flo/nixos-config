{...}: {
  programs.zed-editor = {
    enable = true;

    userSettings = {
      telemetry = {
        metrics = false;
      };

      window_decorations = "server";
      vim_mode = false;
      format_on_save = "off";
      hard_tabs = false;
      tab_size = 2;

      terminal = {
        cursor_shape = "bar";
        shell.program = "bash";
      };

      git.inline_blame.enabled = false;

      languages = {
        "Nix" = {
          enable_language_server = false;
        };
        "Nginx" = {
          enable_language_server = false;
        };
      };
    };
  };
}
