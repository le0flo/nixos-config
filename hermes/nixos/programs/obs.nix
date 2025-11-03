{lib, config, pkgs, ...}: {
  options.obs.enable = lib.mkEnableOption "obs and virtual camera";

  config = lib.mkIf config.obs.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;

      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
      ];
    };
  };
}
