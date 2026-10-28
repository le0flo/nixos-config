{lib, modulesPath, pkgs, ...}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      grub = {
        enable = true;
        devices = lib.mkForce [ "/dev/vda" ];
      };

      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    initrd.availableKernelModules = [
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
    ];
  };
}
