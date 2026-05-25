{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
  ini = pkgs.formats.iniWithGlobalSection {};
  settings = {
    globalSection = {
      actions = true;
      ignore-timeout = false;

      background-color = style.colors.background;
      text-color = style.colors.text;
      border-color = style.colors.border;
    };
  };
in {
  xdg.config.files."mako/config".source = ini.generate "config" settings;
}
