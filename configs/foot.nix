{pkgs, ...}:

{
  xdg.config.files."foot/foot.ini" = {
    type = "copy";
    permissions = "664";

    generator = (pkgs.formats.ini {}).generate "foot.ini";
    value = {
      main = {
        font = "ComicShannsMono Nerd Font Mono:style=Regular:size=16";
        pad = "8x8";
      };
    };
  };
}
