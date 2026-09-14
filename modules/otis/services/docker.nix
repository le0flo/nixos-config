{config, customLib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  cfg = config.otis.services.docker;
in {
  options.otis.services.docker.enable = mkBoolOption "Docker engine" false;

  config = {
    virtualisation.docker = { inherit (cfg) enable; };
  };
}
