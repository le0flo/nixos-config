{pkgs, ...}:

let
  ini = pkgs.formats.iniWithGlobalSection {};
  settings = {
    globalSection = {
      actions = true;
      ignore-timeout = false;
    };
  };
in {
  xdg.config.files."mako/config".source = ini.generate "config" settings;
}
