{...}:

{
  imports = [
    ../../services/audio.nix
    ../../services/power.nix
    ../../services/docker.nix
    ../../services/virt-manager.nix
  ];

  services = {
    blueman.enable = true;
    dbus.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    printing.enable = true;
    tumbler.enable = true;
  };
}
