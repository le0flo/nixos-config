{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "boot.shell_on_fail" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
    };

    loader = {
      timeout = 3;

      grub = {
        enable = true;
        devices = [ "nodev" ];

        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };

    supportedFilesystems = [
      "exfat"
      "ntfs"
    ];
  };
}
