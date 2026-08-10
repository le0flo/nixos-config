{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    types;
in {
  options.otis.programs.archive.enable = mkEnableOption "Add archive programs";

  config =
    let
      archive = config.otis.programs.archive;
    in mkIf archive.enable {
      environment.systemPackages = with pkgs; [
        zip
        unzip
        p7zip
        gnutar
      ];
    };      
}
