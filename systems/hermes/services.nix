{...}: {
  imports = [
    ../../components/services/audio.nix
    ../../components/services/power.nix
    ../../components/services/i2pd.nix
  ];

  services = {
    gvfs.enable = true;
    dbus.enable = true;

    libinput.enable = true;
    printing.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
  };
}
