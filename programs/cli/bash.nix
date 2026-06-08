{...}:

{
  programs.bash = {
    enable = true;
    vteIntegration = true;

    promptInit = ''
      export PS1='\[$(tput bold)$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 6)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput sgr0)\]\$ '
    '';

    shellAliases = {
      "l" = "ls -lh";
      "ll" = "ls -lah";
    };
  };
}
