{config, lib, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/31eed536-5936-4814-bb60-73fcc4fabdc5";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1DD7-85F5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/media" = {
      device = "/dev/disk/by-uuid/d441ef68-e6c5-4407-8ab4-f85855c2848a";
      fsType = "ext4";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/8478cb29-8a67-4842-b9ed-16a226506cb7"; }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
