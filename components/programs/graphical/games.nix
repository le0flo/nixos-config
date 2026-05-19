{pkgs, ...}:

{
  hardware.steam-hardware.enable = true;
  programs.steam.enable = true;

  environment = {
    systemPackages = with pkgs; [
      prismlauncher
      heroic
      bolt-launcher

      gpu-screen-recorder
      gpu-screen-recorder-gtk
    ];

    sessionVariables."_JAVA_AWT_WM_NONREPARENTING" = "1";
  };
}
