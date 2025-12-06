{lib, config, pkgs, ...}: {
  options.sway.enable = lib.mkEnableOption "sway wm";

  config = lib.mkIf config.sway.enable {
    programs.sway = {
      enable = true;
      xwayland.enable = true;

      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      extraPackages = with pkgs; [
        swaybg swayidle swaylock
        light grim wl-clipboard wmenu
      ];
    };
  };
}
