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

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "boot.shell_on_fail" ];

    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
  };
}
