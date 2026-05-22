{...}:

{
  imports = [
    ../../services/audio.nix
    ../../services/power.nix
    ../../services/secrets.nix
    ../../services/tor.nix
    ../../services/i2pd.nix
  ];

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

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
