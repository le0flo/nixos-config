{...}:

{
  imports = [
    ../../services/audio.nix
    ../../services/power.nix
    ../../services/secrets.nix
    ../../services/docker.nix
    ../../services/virt-manager.nix
    ../../services/tor.nix
    ../../services/i2pd.nix
  ];

  services = {
    blueman.enable = true;
    dbus.enable = true;
    flatpak.enable = true;
    gvfs.enable = true;
    libinput.enable = true;
    printing.enable = true;
    tumbler.enable = true;
  };
}
