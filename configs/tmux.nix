{...}:

{
  xdg.config.files."tmux/tmux.conf".text = ''
    set -g base-index 1
    setw -g pane-base-index 1
    setw -g clock-mode-style 24
  '';
}
