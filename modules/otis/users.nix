{config, lib, ...}:

let
  inherit (builtins) mapAttrs;
  
  inherit (lib)
    mkMerge
    mkOption
    types;
in {
  options.otis.users = mkOption {
    type = types.attrsOf (types.submodule {
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
    });
    description = "List of users";
    default = {};
  };

  config = mkMerge mapAttrs (x: y: {
    users.users."${x}" = {
      inherit (y) isNormalUser;

      extraGroups = y.groups;
    };

    hjem.users."${x}" = {
      directory = "/home/${x}";
      clobberFiles = true;
    };
  }) config.otis.users;
}
