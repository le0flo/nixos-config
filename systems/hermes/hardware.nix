{inputs, config, lib, modulesPath, pkgs, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
  ];

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

  hardware = {
    bluetooth.enable = true;

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver intel-ocl intel-vaapi-driver ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
