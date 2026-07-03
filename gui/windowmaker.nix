{config, inputs, pkgs, ...}:

{
  services.xserver = {
    enable = true;
    windowManager.windowmaker.enable = true;

    displayManager = {
      lightdm.enable = false;
      startx.enable = true;
    };

    xkb.layout = "it";
  };

  nixpkgs.overlays = [
    inputs.gnustep-nix.overlays.${config.nixpkgs.hostPlatform.system}
  ];
  
  environment.systemPackages = with pkgs; [
    dockapps.cputnik
    dockapps.wmacpi
    dockapps.wmclockmon
    dockapps.wmnd
    dockapps.wmpulsemixer
    dockapps.wmsystemtray

    addresses
    gnumail
  ];
}
