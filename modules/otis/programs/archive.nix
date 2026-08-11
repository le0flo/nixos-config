{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  archive = config.otis.programs.archive;
in {
  options.otis.programs.archive.enable = mkEnableOption "Add archive programs";

  config = mkIf archive.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
      p7zip
      gnutar
    ];
  };      
}
