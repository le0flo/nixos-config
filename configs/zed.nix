{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
  json = pkgs.formats.json {};
  settings = {
    telemetry.metrics = false;

    theme = {
      mode = style.polarity;
      light = "Ayu Light";
      dark = "Ayu Dark";
    };

    window_decorations = "server";
    restore_on_startup = "empty_tab";
    project_panel.dock = "left";
    git_panel.dock = "left";
    agent.dock = "right";
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

    agent_servers = {
      opencode.type = "registry";
    };
  };
in {
  xdg.config.files."zed/settings.json" = {
    type = "copy";
    permissions = "644";

    source = json.generate "settings.json" settings;
  };
}
