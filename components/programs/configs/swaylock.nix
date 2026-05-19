{pkgs, ...}:

{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      indicator-idle-visible = true;
      indicator-radius = 100;

      clock = true;
      timestr = "%H:%M:%S";
      datestr = "%d %B";
    };
  };
}
