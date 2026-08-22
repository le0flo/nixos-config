{inputs, lib, modulesPath, pkgs, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = lib.mkForce [ "/dev/sda" ];
      };

      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd.availableKernelModules = [
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
    ];
  };

  disko.devices.disk."main" = {
    device = "/dev/sda";
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
}
