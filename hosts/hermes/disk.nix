{...}:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/d2dbb171-8b65-4c40-9f09-d4e7b83f0094";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/ACC0-F37A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/d5e4b700-4eb2-4b19-8d7f-8a8e154a4df1"; }
  ];
}
