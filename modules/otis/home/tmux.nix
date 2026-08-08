{...}:

{
  xdg.config.files."tmux/tmux.conf" = {
    type = "copy";
    permissions = "644";

    text = ''
      set -g mouse on
      set -g base-index 1
      setw -g pane-base-index 1
      setw -g clock-mode-style 24
    '';
  };
}
