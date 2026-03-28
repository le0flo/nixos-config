{...}: {
  imports = [
    ../../components/services/i2pd.nix
  ];

  services = {
    dbus.enable = true;
    libinput.enable = true;
    printing.enable = true;
    blueman.enable = true;
    flatpak.enable = true;

    # Audio
    pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Power
    tlp.enable = false;
    tuned = {
      enable = true;
      ppdSupport = true;
    };
  };

  # Custom modules
  i2pd.enable = true;
}
