{...}: {
  imports = [
    ../../components/services/audio.nix
    ../../components/services/power.nix

    ../../components/services/tor.nix
    ../../components/services/i2pd.nix
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
  };
}
