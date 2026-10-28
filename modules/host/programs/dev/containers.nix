{config, customLib, lib, ...}:

let
  inherit (config.hostConfig.programs) dev;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.programs.dev.containers;
in {
  options.hostConfig.programs.dev.containers.enable = mkBoolOption "Container runtimes" false;

  config = mkIf (cfg.enable && dev.enable) {
    virtualisation = {
      docker.enable = true;
      podman.enable = true;
    };
  };
}
