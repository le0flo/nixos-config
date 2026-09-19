{config, customLib, hostName, lib, pkgs, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (customLib.opts)
    mkAttrSubOption
    mkBoolOption
    mkIntOption
    mkNullOption;

  inherit (lib)
    mkMerge
    types;

  cfg = config.sirah;

  groupOpts.options = {
    id = mkNullOption types.int "Group's id" null;
  };

  userOpts.options = {
    group = mkNullOption types.str "The user's group" null;
    isNormalUser = mkBoolOption "Whether the user is a normal behaving user" true;
    isSystemUser = mkBoolOption "Whether the user is a system user" false;
    id = mkNullOption types.int "User's id" null;
  };
in {
  imports = [
    ./net
    ./services
    ./shares
  ];

  options.sirah = {
    cpu = mkIntOption "Number of cpu cores" 1;
    memory = mkIntOption "Allocated memory (MB)" 1024;
    disk = mkIntOption "Allocated storage (MB)" 8192;

    groups = mkAttrSubOption groupOpts "Set of groups" {};
    users = mkAttrSubOption userOpts "Set of users" {};
  };

  config = {
    environment.systemPackages = with pkgs; [
      htop
      tcpdump
    ];

    microvm = {
      hypervisor = "cloud-hypervisor";
      mem = cfg.memory;
      vcpu = cfg.cpu;

      volumes = [{
        image = "data-${hostName}.img";
        mountPoint = "/var/lib";
        size = cfg.disk;
      }];
    };

    users = {
      groups = mapAttrs (x: y: { gid = y.id; }) cfg.groups;
      users = mkMerge [
        (mapAttrs (x: y: {
          inherit (y) group isNormalUser isSystemUser;
          uid = y.id;
        }) cfg.users)
        {
          "root".openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcXQtfp/MZUibmmXM5xZGHEhLDUGCSKu0+fH9Mh3+Qa leo@odino"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1B/uxIDrKCh5PuJbJN92Dzs8zZjSywJ4LoSZZtFViS leo@thor"
          ];
        }
      ];
    };

    services.getty.autologinUser = "root";

    system.stateVersion = "26.05";

    time.timeZone = "Europe/Rome";
  };
}
