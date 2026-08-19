{config, inputs, lib, modulesPath, pkgs, self, ...}:

let
  selfPkgs = self.packages."${config.nixpkgs.hostPlatform.system}";
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = true;
    intel-gpu-tools.enable = true;
    nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;

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
  };
}
