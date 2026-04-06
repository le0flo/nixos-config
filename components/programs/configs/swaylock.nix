{...}: {
  programs.swaylock = {
    enable = true;

    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      indicator-idle-visible = false;
      indicator-radius = 100;
    };
  };
}
