{pkgs, ...}:

let
  ini = pkgs.formats.ini {};
  settings = {
    core.editor = "vim";
    init.defaultBranch = "master";
  };
in {
  xdg.config.files."git/config".source = ini.generate "config" settings;
}
