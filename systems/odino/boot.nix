{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "boot.shell_on_fail" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    loader = {
      timeout = 3;

      grub = {
        enable = true;
        devices = [ "nodev" ];

        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
