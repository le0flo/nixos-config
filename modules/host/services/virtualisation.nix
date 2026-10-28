{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkMerge
    mkIf;

  cfg = config.hostConfig.services.virtualisation;
in {
  options.hostConfig.services.virtualisation.enable = mkBoolOption "Virtualisation tools" false;

  config = mkIf cfg.enable (mkMerge [
    {
      virtualisation = {
        libvirtd = {
          enable = true;

        };
        lxc = {
          enable = true;
        };
        spiceUSBRedirection.enable = true;
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = [ pkgs.virt-manager ];
    })
  ]);
}
