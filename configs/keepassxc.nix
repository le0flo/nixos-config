{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."keepassxc/keepassxc.ini" = {
    type = "copy";
    permissions = "644";

    generator = (pkgs.formats.ini {}).generate "keepassxc.ini";
    value = {
      Browser.Enabled=true;
      GUI.ApplicationTheme = style.polarity;
      Security.Security_HideNotes=true;

      PasswordGenerator = {
        Length = 128;
        LowerCase = true;
        UpperCase = true;
        SpecialChars = true;
      };
    };
  };
}
