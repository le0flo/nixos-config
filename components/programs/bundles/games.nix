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

    gpu-screen-recorder
    gpu-screen-recorder-gtk
  ];
}
