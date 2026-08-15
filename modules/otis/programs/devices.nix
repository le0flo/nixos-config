{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  devices = config.otis.programs.devices;
  gui = config.otis.gui;
in {
  options.otis.programs.devices.enable = mkEnableOption "Add external devices tools and drivers";

  config = mkIf devices.enable (mkMerge [
    {
      boot.supportedFilesystems = [
        "exfat"
        "ntfs"
      ];

      environment.systemPackages = with pkgs; [
        exfat
        ntfs3g
        android-tools
      ];        
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        scrcpy
        veracrypt
      ];        
    })
  ]);
}
