{config, inputs, pkgs, ...}:

{
  imports = [ ./base.nix ];

  services.xserver.windowManager.windowmaker.enable = true;

  xdg.portal = {
    config."windowmaker".default = [ "gtk" ];

    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  nixpkgs.overlays = [
    inputs.gnustep.overlays.${config.nixpkgs.hostPlatform.system}
  ];

  environment = {
    shellAliases."start-windowmaker" = "startx ~/GNUstep/Defaults/WMStart.sh";

    systemPackages = with pkgs; [
      dockapps.cputnik
      dockapps.wmacpi
      dockapps.wmclockmon
      dockapps.wmnd
      dockapps.wmpulsemixer
      dockapps.wmsystemtray
    ];
  };
}
