{lib, pkgs, ...}:

{
  boot = {
    loader = {
      grub = {
        enable = true;
        devices = lib.mkForce [ "/dev/sda" ];
      };

      timeout = 3;
    };

    kernel.sysctl."net.ipv4.ip_forward" = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
  };
}
