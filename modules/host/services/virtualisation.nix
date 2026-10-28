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
      environment.etc."libvirt/networks/customnat.xml".text = ''
      <network>
        <name>customnat</name>
        <forward mode="nat"/>
        <bridge name="virbr-nat">
        <ip address="10.67.0.1" netmask="255.255.0.0">
          <dhcp><range start="10.67.1.1" end="10.67.1.253"/></dhcp>
        </ip>
      </network>
      '';

      virtualisation = {
        libvirtd = {
          enable = true;
          qemu.vhostUserPackages = [ pkgs.virtiofsd ];
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
