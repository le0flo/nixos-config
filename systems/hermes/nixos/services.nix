{...}: {
  imports = [
    ../../../components/services/i2pd.nix
  ];

  services = {
    dbus.enable = true;
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
    blueman.enable = true;

    # Flatpaks
    flatpak.enable = true;

    # Audio
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Custom modules
  i2pd.enable = true;
}
