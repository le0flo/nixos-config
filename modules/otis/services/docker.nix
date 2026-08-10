{config, lib, ...}:

let
  inherit (lib) mkEnableOption;
in {
  options.otis.services.docker.enable = true;

  config =
    let
      docker = config.otis.services.docker;
    in  {
      virtualisation.docker.enable = docker.enable;
    };
}
