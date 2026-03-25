{lib, config, ...}: {
  options.tmux.enable = lib.mkEnableOption "Tmux";

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      clock24 = true;
    };
  };
}
