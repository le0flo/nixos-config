{config, lib, pkgs, self, ...}:

let
  inherit (builtins) mapAttrs;
  
  inherit (lib)
    flatten
    mkForce
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

          ssh.authorizedKeys = mkOption {
            type = with types; listOf str;
            description = "List of allowed ssh keys";
            default = [];
          };
        };
      });
      description = "Set of users";
      default = {};
    };

    hjem = mkOption {
      type = with types; listOf attrs;
      description = "List of attributes for all the hjem configurations";
      default = [];
    };
  };

  config = {
    hjem.users = mapAttrs (x: y: mkMerge (flatten [
      {
        directory = "/home/${x}";
        clobberFiles = mkForce true;
      }
      config.otis.hjem
    ])) config.otis.users;

    users.users = mapAttrs (x: y: {
      inherit (y) isNormalUser;

      extraGroups = y.groups;
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = y.ssh.authorizedKeys;
    }) config.otis.users;

    nixpkgs.overlays = [ self.overlays."${config.nixpkgs.hostPlatform.system}" ];

    services.fwupd.enable = true;
  };
}
