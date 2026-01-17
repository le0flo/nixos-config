{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_6_18; # NOTE: soltanto versioni LTS per il server
    kernelParams = [ "boot.shell_on_fail" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
