{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
  ini = pkgs.formats.ini {};
  settings = {
    Browser.Enabled=true;

    GUI = {
      ApplicationTheme = style.polarity;
      HideUsernames = true;
    };

    PasswordGenerator = {
      Length = 128;
      LowerCase = true;
      UpperCase = true;
      SpecialChars = true;
    };
  };
in {
  xdg.config.files."keepassxc/keepassxc.ini" = {
    type = "copy";
    permissions = "644";

    source = ini.generate "config" settings;
  };
}
