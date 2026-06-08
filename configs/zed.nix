{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."zed/settings.json" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.json {}).generate "settings.json";
    value = {
      telemetry.metrics = false;
      disable_ai = true;

      buffer_font_size = 20.0;
      buffer_font_family = "Iosevka Nerd Font Mono";

      theme = {
        mode = style.polarity;
        light = "Ayu Light";
        dark = "Ayu Dark";
      };

      window_decorations = "server";
      restore_on_startup = "empty_tab";
      project_panel.dock = "left";
      git_panel.dock = "left";
      outline_panel.button = false;

      vim_mode = false;
      format_on_save = "off";
      hard_tabs = false;
      tab_size = 2;
      git.inline_blame.enabled = false;

      languages = {
        "Nix".enable_language_server = false;
        "Nginx".enable_language_server = false;
      };

      terminal = {
        cursor_shape = "bar";
        shell.program = "bash";
      };
    };
  };
}
