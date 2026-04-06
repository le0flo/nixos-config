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
        shell.program = "zsh";

        cursor_shape = "bar";
      };
    };
  };
}
