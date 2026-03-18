{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18; # NOTE: soltanto versioni LTS per il server

    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    extraModulePackages = [ ];
  };
}
