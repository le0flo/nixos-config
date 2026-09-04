{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.devices;
in {
  options.otis.programs.devices.enable = mkBoolOption "Add external devices tools and drivers" false;

  config = mkIf cfg.enable (mkMerge [
    {
      boot.supportedFilesystems = [
        "exfat"
        "ntfs"
        "f2fs"
      ];

      environment.systemPackages = with pkgs; [
        exfat
        ntfs3g
        f2fs-tools
        android-tools
        wine
      ];        
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [ scrcpy ];
    })
  ]);
}
