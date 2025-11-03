{config, ...}: {
  boot = {
    consoleLogLevel = 3;

    kernelParams = [
      "quiet"
      "splash"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = "options v4l2loopback devices=1 video_nr=1 card_label=\"OBS Cam\" exclusive_caps=1";

    loader = {
      timeout = 3;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };
}
