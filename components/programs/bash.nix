{...}: {
  programs.bash = {
    enable = true;
    vteIntegration = true;

    promptInit = ''
      export PS1='\e[1m\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 6)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\e(B\e[m\$ '
    '';

    shellAliases = {
      l = "ls -lh";
      ll = "ls -lah";

      ssh = "TERM=xterm-256color ssh";
    };
  };
}
