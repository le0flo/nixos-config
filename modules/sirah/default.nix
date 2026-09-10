{config, customLibs, lib, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (customLibs.cake.opts)
    mkAttrSubOption
    mkBoolOption
    mkNullOption;

  inherit (lib) types;

  groupOpts.options = {
    id = mkNullOption types.int "Group's id" null;
  };

  userOpts.options = {
    group = mkNullOption types.str "The user's group" null;
    isNormalUser = mkBoolOption "Whether the user is a normal behaving user" true;
    isSystemUser = mkBoolOption "Whether the user is a system user" false;
    id = mkNullOption types.int "User's id" null;
  };

  cfg = config.sirah;
in {
  imports = [
    ./net
    ./shares
  ];

  options.sirah = {
    groups = mkAttrSubOption groupOpts "Set of groups" {};
    users = mkAttrSubOption userOpts "Set of users" {};
  };

  config = {
    users = {
      groups = mapAttrs (x: y: { gid = y.id; }) cfg.groups;
      users = mapAttrs (x: y: {
        inherit (y) group isNormalUser isSystemUser;

        uid = y.id;
      }) cfg.users;
    };
  };
}
