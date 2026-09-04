{config, customLibs, lib, pkgs, self, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (customLibs.otis.opts)
    mkAttrSubOption
    mkBoolOption
    mkListOption;

  inherit (lib)
    flatten
    mkDefault
    mkForce
    mkMerge
    types;

  userOpts.options = {
    groups = mkListOption types.str "Groups assigned to that user" [];
    isNormalUser = mkBoolOption "Whether the user is a normal behaving user" true;
    ssh.authorizedKeys = mkListOption types.str "List of allowed ssh keys" [];
  };    

  cfg = config.otis;
in {
  imports = [
    ./gui
    ./net
    ./programs
    ./services
  ];

  options.otis = {
    users = mkAttrSubOption userOpts "Set of users" {};
    hjem = mkListOption types.attrs "List of attributes for all the hjem configurations" [];
  };

  config = {
    hjem.users = mapAttrs (x: y: mkMerge (flatten [
      {
        directory = "/home/${x}";
        clobberFiles = mkForce true;
      }
      cfg.hjem
    ])) cfg.users;

    users.users = mapAttrs (x: y: {
      inherit (y) isNormalUser;

      extraGroups = y.groups;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = y.ssh.authorizedKeys;
    }) cfg.users;

    nixpkgs.overlays = [ self.overlays."${system}" ];

    services.fwupd.enable = mkDefault true;
  };
}
