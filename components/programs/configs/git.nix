{...}:

{
  programs.git = {
    enable = true;

    settings = {
      core.editor = "vim";
      init.defaultBranch = "master";
    };
  };
}
