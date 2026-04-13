{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18;

    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
    ];

    loader = {
      timeout = 3;

      grub = {
        enable = true;

        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
