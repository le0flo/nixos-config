{pkgs, ...}:

{
  xdg.config.files."git/config" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.ini {}).generate "config";
    value = {
      core.editor = "nano";
      init.defaultBranch = "master";
    };
  };
}
