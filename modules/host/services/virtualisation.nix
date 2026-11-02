{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib)
    mkMerge
    mkIf;

  cfg = config.hostConfig.services.virtualisation;
in {
  options.hostConfig.services.virtualisation = {
    enable = mkBoolOption "Virtualisation tools" false;
    vmsPath = mkStrOption "Virtual machine path" "/mnt/storage/vms";
    virtiofsd = mkBoolOption "External virtiofsd daemon" true;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs.virtiofsd ];

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu.vhostUserPackages = [ pkgs.virtiofsd ];
        };
        lxc.enable = true;
        spiceUSBRedirection.enable = true;
      };

      systemd.services."virtiofsd-ext" = {
        description = "External virtiofsd daemon";
        path = [ pkgs.virtiofsd ];

        wantedBy = if cfg.virtiofsd then [ "multi-user.target" ] else [];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          Restart = "no";
          ExecStart = "${pkgs.ssm}/bin/ssm ${cfg.vmsPath}/virtiofsd";

          KillSignal = "SIGTERM";
          KillMode = "control-group";
          TimeoutStopSec = "30s";
        };
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = [ pkgs.virt-manager ];
    })
  ]);
}
