{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
  json = pkgs.formats.json {};
  settings = {
    telemetry.metrics = false;
    disable_ai = true;

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
in {
  xdg.config.files."zed/settings.json" = {
    type = "copy";
    permissions = "644";

    source = json.generate "settings.json" settings;
  };
}
