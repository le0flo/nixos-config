{...}: {
  imports = [
    ./i2pd.nix
  ];

  # Security
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  # Audio
  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Services
  services = {
    dbus.enable = true;
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    flatpak.enable = true;
    printing.enable = true;
  };

  # Custom
  i2pd.enable = true;
}
