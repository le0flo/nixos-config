{pkgs, ...}: {
  boot = {
    consoleLogLevel = 4;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "boot.shell_on_fail" ];

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "exfat" "ntfs" ];
  };
}
