{pkgs, ...}:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };

      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_7_0;
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
  };
}
