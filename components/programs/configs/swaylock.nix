{...}: {
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
}
