{
  programs.bash = {
    enable = true;
    vteIntegration = true;

    interactiveShellInit = ''
    env_dir="$HOME/.config/env"

    if [[ -d "$env_dir" ]]; then
      set -a
      for env_file in "$env_dir"/*.env; do
        test -f "$env_file" || continue
        source "$env_file"
      done
      set +a
    fi
    '';

    promptInit = ''
    export PS1='\[$(tput bold)$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 6)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput sgr0)\]\$ '
    '';

    shellAliases = {
      "l" = "ls -lh --group-directories-first";
      "ll" = "ls -lah --group-directories-first";
    };
  };
}
