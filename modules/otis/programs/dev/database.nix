{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (config.otis.programs) dev;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.dev.database;
in {
  options.otis.programs.dev.database.enable = mkBoolOption "Database related" false;

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
