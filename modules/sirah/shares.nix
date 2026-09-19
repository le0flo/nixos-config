{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    filter
    length;

  inherit (customLib.opts)
    mkBoolOption
    mkListSubOption
    mkStrOption;

  inherit (lib)
    drop
    mkIf
    mkMerge
    splitString;

  cfg = config.sirah.shares;

  shareOpts.options = {
    host = {
      dir = mkStrOption "Directory to share with the guest" "";
      uid = mkStrOption "The uid of the host owner" "";
      gid = mkStrOption "The gid of the host owner" "";
    };

    guest = {
      dir = mkStrOption "Destination on the guest fs" "";
      uid = mkStrOption "The uid of the guest owner" "";
      gid = mkStrOption "The gid of the guest owner" "";
    };

    readOnly = mkBoolOption "Whether to make the directory read only" true;
  };

  mountValid = filter (x: x.readOnly == false) cfg;
  mountNames = map (x: mountName x.guest.dir) mountValid;

  mountName = dir: "${concatStringsSep "-" (drop 1 (splitString "/" dir))}.mount";
in {
  options.sirah.shares = mkListSubOption shareOpts "List of shares for the microvm" [];

  config = {
    microvm.shares = map (x: mkMerge [
      {
        inherit (x) readOnly;
        proto = "virtiofs";

        source = x.host.dir;
        mountPoint = x.guest.dir;
        tag = mountName x.guest.dir;
      }
      (mkIf (x.readOnly == false) {
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:${x.guest.uid}:${x.host.uid}:1"
          "--translate-gid" "map:${x.guest.gid}:${x.host.gid}:1"
        ];
      })
    ]) cfg;

    systemd.services."fs-fix" = mkIf ((length mountValid) > 0) {
      wantedBy = [ "multi-user.target" ];
      after = mountNames;
      requires = mountNames;

      serviceConfig = {
        Type = "oneshot";
        ExecStart = concatStringsSep "\n" (map (x: "${pkgs.coreutils}/bin/chmod 755 ${x.guest.dir}") mountValid);
      };
    };
  };
}
