{modulesPath, pkgs, ...}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.cpu.intel.updateMicrocode = true;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };

      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    initrd.availableKernelModules = [
      "ahci"
      "kvm-intel"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];
  };

  disko.devices.disk."main" = {
    device = "/dev/nvme0n1";
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

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ext4";

    options = [
      "nofail"
      "x-systemd.device-timeout=1s"
    ];
  };
}
