{config, customLib, hostName, lib, pkgs, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (customLib.opts)
    mkAttrSubOption
    mkIntOption
    mkNullOption;

  inherit (lib)
    mkDefault
    mkForce
    mkMerge
    types;

  cfg = config.sirah;

  groupOpts.options = {
    id = mkNullOption types.int "Group's id" null;
  };

  userOpts.options = {
    id = mkNullOption types.int "User's id" null;
  };
in {
  imports = [
    ./services

    ./net.nix
    ./shares.nix
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
      groups = mapAttrs (x: y: { gid = mkForce y.id; }) cfg.groups;
      users = mkMerge [
        (mapAttrs (x: y: { uid = mkForce y.id; }) cfg.users)
        {
          "root".openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAcXQtfp/MZUibmmXM5xZGHEhLDUGCSKu0+fH9Mh3+Qa leo@odino"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP1B/uxIDrKCh5PuJbJN92Dzs8zZjSywJ4LoSZZtFViS leo@thor"
          ];
        }
      ];
    };

    services = {
      getty.autologinUser = "root";
      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
    };

    system.stateVersion = "26.05";

    time.timeZone = "Europe/Rome";
  };
}
