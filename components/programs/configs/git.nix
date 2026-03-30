{...}: {
  programs.git = {
    enable = true;

    extraConfig = {
      core.editor = "vim";
      init.defaultBranch = "master";
    };
  };
}
