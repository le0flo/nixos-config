{lib, config, ...}: {
  options.swaylock.enable = lib.mkEnableOption "Swaylock";

  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;

      settings = {
        ignore-empty-password = true;
        show-failed-attempts = true;

        indicator-idle-visible = false;
        indicator-radius = 100;

        font-size = 24;
        color = "010101";
      };
    };
  };
}
