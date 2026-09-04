{config, customLibs, lib, pkgs, ...}:

let
  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.programs.archive;
in {
  options.otis.programs.archive.enable = mkBoolOption "Add archive programs" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
      p7zip
      gnutar
    ];
  };      
}
