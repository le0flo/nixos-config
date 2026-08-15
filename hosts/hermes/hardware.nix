{config, inputs, lib, modulesPath, pkgs, self, ...}:

let
  selfPkgs = self.packages."${config.nixpkgs.hostPlatform.system}";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = true;
    intel-gpu-tools.enable = true;
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";

        splashImage = "${selfPkgs.wallpapers}/share/wallpapers/gnulove.jpg";
      };

      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "boot.shell_on_fail"
      "i8042.nomux=1"
    ];

    initrd.availableKernelModules = [
      "kvm-intel"
      "nvme"
      "sd_mod"
      "sdhci_pci"
      "usb_storage"
      "xhci_pci"
    ];
  };

  /* TODO: usare disko
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
            type = "luks";
            name = "cifrato";
            settings.allowDiscards = true;

            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };*/
  
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
