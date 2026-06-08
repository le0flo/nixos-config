{pkgs, ...}:

{
  xdg.config.files."git/config" = {
    type = "copy";
    permissions = "664";

    generator = (pkgs.formats.ini {}).generate "config";
    value = {
      core.editor = "vis";
      init.defaultBranch = "master";
    };
  };
}
