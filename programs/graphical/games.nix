{pkgs, ...}:

{
  hardware.steam-hardware.enable = true;
  programs.steam.enable = true;

  environment = {
    systemPackages = with pkgs; [
      prismlauncher
      heroic
    ];

    sessionVariables."_JAVA_AWT_WM_NONREPARENTING" = "1";
  };
}
