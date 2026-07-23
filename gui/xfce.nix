{config, inputs, pkgs, ...}:

{
  services.xserver = {
    enable = true;
    
    desktopManager.xfce = {
      enable = true;
      enableWaylandSession = true;
      waylandSessionCompositor = "xfwl4";
    };
  };

  xdg.portal = {
    config."xfce".default = [ "gtk" ];
    
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };
  
  nixpkgs.overlays = [
    inputs.xfce-nix.overlays.${config.nixpkgs.hostPlatform.system}
  ];

  environment.xfce.excludePackages = with pkgs; [ parole ];

  environment.systemPackages = with pkgs; [ xfwl4 ];
}
