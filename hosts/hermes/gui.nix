{pkgs, ...}:

{
  imports = [
    ../../gui/fonts.nix
    ../../gui/niri.nix
    ../../gui/windowmaker.nix
  ];

  services.xserver = {
    enable = true;
    
    desktopManager.xterm.enable = false;

    displayManager = {
      lightdm.enable = false;
      startx.enable = true;
    };

    deviceSection = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
    
    videoDrivers = [ "modesetting" ];
  };

  programs.uwsm.enable = true;

  xdg = {
    icons.enable = true;
    autostart.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
