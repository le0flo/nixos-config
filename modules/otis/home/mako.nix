{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."mako/config" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.iniWithGlobalSection {}).generate "config";
    value = {
      globalSection = {
        actions = true;
        ignore-timeout = false;

        background-color = style.colors.background;
        text-color = style.colors.text;
        border-color = style.colors.border;
        
        outer-margin = 0;
        margin = 5;
      };
    };
  };
}
