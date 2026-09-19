{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (customLib.opts)
    mkAttrOption
    mkAttrSubOption
    mkBoolOption
    mkListOption
    mkPkgsOption;

  inherit (lib)
    flatten
    mkForce
    mkMerge
    types;

  cfg = config.otis;

  userOpts.options = {
    groups = mkListOption types.str "Groups assigned to that user" [];
    isNormalUser = mkBoolOption "Whether the user is a normal behaving user" true;
    packages = mkPkgsOption "Additional packages" [];
    ssh.authorizedKeys = mkListOption types.str "List of allowed ssh keys" [];
  };
in {
  imports = [
    ./gui
    ./net
    ./programs
    ./services

    ./locale.nix
    ./system.nix
  ];

  options.otis = {
    users = mkAttrSubOption userOpts "Set of users" {};
    hjem = mkListOption types.attrs "List of attributes for all the hjem configurations" [];
    secrets = mkAttrOption "Set of agenix secrets" {};
  };

  config = {
    age = {
      inherit (cfg) secrets;

      identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    hjem.users = mapAttrs (x: y: mkMerge (flatten ([{
      directory = "/home/${x}";
      clobberFiles = mkForce true;
    }] ++ cfg.hjem))) cfg.users;

    users.users = mapAttrs (x: y: {
      inherit (y) isNormalUser packages;

      extraGroups = y.groups;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = y.ssh.authorizedKeys;
    }) cfg.users;
  };
}
