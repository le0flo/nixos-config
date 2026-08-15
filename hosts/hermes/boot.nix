{config, pkgs, self, ...}:

let
  selfPkgs = self.packages."${config.nixpkgs.hostPlatform.system}";
in {
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;

        splashImage = "${selfPkgs.wallpapers}/share/wallpapers/gnulove.jpg";
      };

      efi.canTouchEfiVariables = true;
      timeout = 3;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "boot.shell_on_fail" "i8042.nomux=1" ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [ ];
    };
  };
}
