{config, customLib, hostName, lib, pkgs, ...}:

let
  inherit (builtins) mapAttrs;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (customLib.opts)
    mkAttrOption
    mkAttrSubOption
    mkNullOption;

  inherit (lib)
    mkForce
    types;

  cfg = config.vmConfig;

  groupOpts.options = {
    id = mkNullOption types.int "Group's id" null;
  };

  userOpts.options = {
    id = mkNullOption types.int "User's id" null;
  };
in {
  imports = [
    ./services

    ./boot.nix
    ./fs.nix
    ./net.nix
  ];

  options.vmConfig = {
    groups = mkAttrSubOption groupOpts "Set of groups" {};
    users = mkAttrSubOption userOpts "Set of users" {};
    secrets = mkAttrOption "Set of agenix secrets" {};
  };

  config = {
    age = {
      inherit (cfg) secrets;

      identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    console.keyMap = "it";

    environment = {
      shellAliases = {
        "vm-build" = "sudo nixos-rebuild build --flake ~/nixos-config#vm-${hostName}-${system}";
        "vm-boot" = "sudo nixos-rebuild boot --flake ~/nixos-config#vm-${hostName}-${system}";
        "vm-switch" = "sudo nixos-rebuild switch --flake ~/nixos-config#vm-${hostName}-${system}";
      };

      systemPackages = with pkgs; [
        git
        htop
        tcpdump
      ];
    };

    users = {
      groups = mapAttrs (x: y: { gid = mkForce y.id; }) cfg.groups;
      users = mapAttrs (x: y: { isSystemUser = true; uid = mkForce y.id; }) cfg.users;
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
