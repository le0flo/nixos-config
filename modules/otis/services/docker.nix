{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.docker;
in {
  options.otis.services.docker.enable = mkBoolOption "Docker engine" false;

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
  };
}
