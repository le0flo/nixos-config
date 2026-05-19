{...}:

{
  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = false;

    tuned = {
      enable = true;
      ppdSupport = true;
    };
  };
}
