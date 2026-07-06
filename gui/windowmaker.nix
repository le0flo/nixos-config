{config, inputs, pkgs, ...}:

{
  services.xserver = {
    enable = true;
    
    windowManager.windowmaker.enable = true;
    desktopManager.xterm.enable = false;
    
    displayManager = {
      lightdm.enable = false;
      startx.enable = true;
    };

    xkb.layout = "it";
  };

  xdg.portal = {
    config."windowmaker".default = [ "gtk" ];
    
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  
  nixpkgs.overlays = [
    inputs.gnustep-nix.overlays.${config.nixpkgs.hostPlatform.system}
  ];
  
  environment.systemPackages = with pkgs; [
    rxvt-unicode
    xclip
    addresses
    gnumail

    dockapps.cputnik
    dockapps.wmacpi
    dockapps.wmclockmon
    dockapps.wmnd
    dockapps.wmpulsemixer
    dockapps.wmsystemtray
  ];
}
