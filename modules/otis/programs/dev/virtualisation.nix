{config, customLib, lib, ...}:

let
  inherit (config.otis.programs) dev;

  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.dev.virtualisation;
in {
  options.otis.programs.dev.virtualisation.enable = mkBoolOption "Virtualisation related" false;

  config = mkIf (cfg.enable && dev.enable) (mkMerge [
    {
      virtualisation = {
        docker.enable = true;
        libvirtd.enable = true;
        podman.enable = true;
        spiceUSBRedirection.enable = true;
      };
    }
    (mkIf gui.enable {
      programs.virt-manager.enable = true;
    })
  ]);
}
