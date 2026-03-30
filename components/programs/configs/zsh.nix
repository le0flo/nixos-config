{pkgs, ...}: {
  home.packages = with pkgs; [ eza ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;

    syntaxHighlighting.enable = true;

    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";

      plugins = [
        "git"
        "ssh"
      ];
    };

    shellAliases = {
      ls = "eza";
      l = "ls -lh";
      ll = "ls -lah";

      ssh = "TERM=xterm-256color ssh";
    };

    initContent = ''
        # Ctrl + arrow keys
        bindkey '^[Oc' forward-word
        bindkey '^[Od' backward-word
        bindkey '^[[1;5D' backward-word
        bindkey '^[[1;5C' forward-word
        bindkey '^H' backward-kill-word

        # Theme
        autoload -U colors
        colors
    '';
  };
}
