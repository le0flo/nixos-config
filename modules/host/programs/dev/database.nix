{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (config.hostConfig.programs) dev;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.programs.dev.database;
in {
  options.hostConfig.programs.dev.database.enable = mkBoolOption "Database related" false;

  config = mkIf (cfg.enable && dev.enable) (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        postgresql
        sqlite
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        dbeaver-bin
        heidisql
      ];
    })
  ]);
}
