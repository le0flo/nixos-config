{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.programs.devices;
in {
  options.hostConfig.programs.devices.enable = mkBoolOption "External devices" false;

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
