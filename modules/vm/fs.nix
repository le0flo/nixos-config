{config, customLib, ...}:

let
  inherit (builtins) listToAttrs;

  inherit (customLib.opts)
    mkListSubOption
    mkStrOption;

  cfg = config.vmConfig.fs;

  shareOpts.options = {
    mountName = mkStrOption "The virtiofs mount name" "";
    guestDir = mkStrOption "Destination on the guest fs" "";
  };
in {
  options.vmConfig.fs.shares = mkListSubOption shareOpts "List of shares for the vm" [];

  config = {
    disko.devices.disk."main" = {
      device = "/dev/vda";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          MBR = {
            type = "EF02";
            size = "1M";
            priority = 1;
          };

          ESP = {
            type = "EF00";
            size = "1G";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "4G";

            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };

          root = {
            size = "100%";

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    fileSystems = listToAttrs (map (x: {
      name = x.guestDir;
      value = {
        device = x.mountName;
        fsType = "virtiofs";

        options = [
          "nofail"
          "x-systemd.device-timeout=1s"
        ];
      };
    }) cfg.shares);
  };
}
