{inputs, lib, modulesPath, pkgs, ...}:

let
  pkgsLocal = import inputs.nixpkgs { localSystem = "x86_64-linux"; };
  pkgsCross = pkgsLocal.pkgsCross.aarch64-multiplatform;

  kernelCross = pkgsCross.callPackage
    "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix"
    { rpiVersion = 4; };
in {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  services.fwupd.enable = lib.mkForce false;
  
  nixpkgs.hostPlatform = "aarch64-linux";

  hardware = {
    enableAllHardware = lib.mkForce false;

    raspberry-pi.firmware = {
      enable = true;
      uboot.enable = true;
    };
  };

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    kernelPackages = lib.mkForce (pkgsCross.linuxPackagesFor kernelCross);
    kernelParams = [ "boot.shell_on_fail" ];

    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "xhci_pci"
    ];

    supportedFilesystems.zfs = lib.mkForce false;
  };
}
