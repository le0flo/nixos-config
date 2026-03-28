{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "boot.shell_on_fail" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
