{config, lib, pkgs, ...}:

let
  inherit (builtins) attrNames;

  inherit (lib) mkMerge;
in {
  config =
    let
      forEachUser = attrs: map (x: { users.users."${x}" = attrs; }) (attrNames config.users.users);
    in mkMerge [
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
    ]
    ++ forEachUser { shell = pkgs.bash; };
}
