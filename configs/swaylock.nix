{pkgs, ...}:

let
  ini = pkgs.formats.iniWithGlobalSection {};
  settings = {
    globalSection = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      indicator-idle-visible = true;
      indicator-radius = 100;

      clock = true;
      timestr = "%H:%M:%S";
      datestr = "%d %B";
    };
  };
in {
  xdg.config.files."swaylock/config".source = ini.generate "config" settings;
}
