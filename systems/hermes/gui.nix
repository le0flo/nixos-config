{pkgs, ...}:

{
  imports = [
    ../../gui/fonts.nix
    ../../gui/niri.nix
    ../../gui/xfce.nix
    ../../gui/windowmaker.nix
  ];

  services.xserver = {
    videoDrivers = [ "modesetting" ];

    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
    
    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = false;
  };

  xdg = {
    icons.enable = true;
    autostart.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };
}
