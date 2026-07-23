{config, inputs, pkgs, ...}:

{
  services.xserver = {
    enable = true;
    
    windowManager.windowmaker.enable = true;
    displayManager.startx.enable = true;
  };

  xdg.portal = {
    config."windowmaker".default = [ "gtk" ];
    
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  
  nixpkgs.overlays = [
    inputs.gnustep-nix.overlays.${config.nixpkgs.hostPlatform.system}
  ];
  
  environment.systemPackages = with pkgs; [
    xterm
    gworkspace
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
