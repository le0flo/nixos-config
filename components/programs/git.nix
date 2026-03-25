{lib, config, ...}: {
  options.git.enable = lib.mkEnableOption "Git SCM";

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;

      config = {
        init = {
          defaultBranch = "master";
        };
        core = {
          editor = "vim";
        };
      };
    };
  };
}
