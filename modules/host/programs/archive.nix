{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.programs.archive;
in {
  options.hostConfig.programs.archive.enable = mkBoolOption "Archiving" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zip
      unzip
      p7zip
      gnutar
    ];
  };
}
