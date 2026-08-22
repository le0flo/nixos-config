{inputs, lib, modulesPath, pkgs, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = true;
    intel-gpu-tools.enable = true;
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader = {
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;

        splashImage = "${pkgs.wallpapers}/share/wallpapers/gnulove.jpg";
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
