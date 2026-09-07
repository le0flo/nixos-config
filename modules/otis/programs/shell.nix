{
  config = {
    programs.bash = {
      enable = true;
      vteIntegration = true;

      interactiveShellInit = ''
      secrets_dir="$HOME/.config/env"

      if [[ -d "$secrets_dir" ]]; then
        set -a
        for env_file in "$secrets_dir"/*.env; do
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
        "l" = "ls -lh";
        "ll" = "ls -lah";
      };
    };
  };
}
