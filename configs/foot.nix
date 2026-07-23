{pkgs, ...}:

{
  xdg.config.files."foot/foot.ini" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.ini {}).generate "foot.ini";
    value = {
      main = {
        term = "xterm-256color";
        font = "ComicShannsMono Nerd Font Mono:style=Regular:size=16";
        pad = "8x8";
      };
    };
  };
}
