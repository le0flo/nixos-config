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
    stty werase '^H'
    export PS1='[\u@\H \W] % '
    '';

    shellAliases = {
      "l" = "ls -lh --group-directories-first";
      "ll" = "ls -lah --group-directories-first";
    };
  };
}
