{config, lib, ...}:

let
  inherit (lib) mkEnableOption;

  docker = config.otis.services.docker;
in {
  options.otis.services.docker.enable = mkEnableOption "Docker engine";

  config = {
    virtualisation.docker.enable = docker.enable;
  };
}
