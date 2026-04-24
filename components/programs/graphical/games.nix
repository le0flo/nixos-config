{pkgs, ...}: {
  # Steam
  hardware.steam-hardware.enable = true;
  programs = {
    gamemode.enable = true;
    steam.enable = true;
  };

  # Launchers
  environment.systemPackages = with pkgs; [
    prismlauncher
    heroic
    bolt-launcher

    gpu-screen-recorder
    gpu-screen-recorder-gtk
  ];

  # Runelite fix
  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
