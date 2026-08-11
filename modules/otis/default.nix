{config, lib, pkgs, ...}:

let
  inherit (builtins) mapAttrs;
  
  inherit (lib)
    flatten
    mkMerge
    mkOption
    types;
in {
  imports = [
    ./gui
    ./net
    ./programs
    ./services
  ];

  options.otis = {
    users = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          groups = mkOption {
            type = with types; listOf str;
            description = "Groups assigned to that user";
            default = [];
          };

          isNormalUser = mkOption {
            type = types.bool;
            description = "Whether the user is a normal behaving user";
            default = true;
          };
        };
      });
      description = "Set of users";
      default = {};
    };

    hjem = mkOption {
      type = types.attrs;
      description = "Attribute set for all the hjem configurations";
      default = {};
    };
  };

  config = {
    users.users = mapAttrs (x: y: {
      inherit (y) isNormalUser;

      extraGroups = y.groups;
      shell = pkgs.bash;
    }) config.otis.users;

    hjem.users = mapAttrs (x: y: {
      directory = "/home/${x}";
      clobberFiles = true;
    } // config.otis.hjem) config.otis.users;
  };
}
