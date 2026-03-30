{...}: {
  xdg.autostart.enable = true;

  programs.keepassxc = {
    enable = true;
    autostart = true;

    settings = {
      Browser.Enabled=true;
      FdoSecrets.Enabled = true;

      GUI = {
        MinimizeOnStartup = true;
        MinimizeOnClose = true;

        ApplicationTheme = "dark";
        HideUsernames = true;
        TrayIconAppearance = "monochrome-light";
      };

      PasswordGenerator = {
        Length = 128;
        LowerCase = true;
        UpperCase = true;
        SpecialChars = true;
      };
    };
  };
}
