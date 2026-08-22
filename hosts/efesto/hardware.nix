{inputs, lib, modulesPath, pkgs, ...}:

{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  hardware.raspberry-pi.firmware.uboot.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    initrd.availableKernelModules = [
      "sd_mod"
      "sdhci_pci"
      "usb_storage"
    ];

    supportedFilesystems.zfs = lib.mkForce false;
  };

  /*
  disko.devices.disk."main" = {
    device = "/dev/sda";
    type = "disk";
    
    content = {
      type = "gpt";

      partitions = {
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
          size = "1G";

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
  };*/
}
