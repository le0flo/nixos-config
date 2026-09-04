{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.hjem) configFmt;

  inherit (lib)
    mkIf
    mkMerge;
in {  
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        rage
        ragenix
        cryptsetup
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [ keepassxc ];

      otis.hjem = [{
        xdg.config.files."keepassxc/keepassxc.ini" = configFmt pkgs.formats.ini "keepassxc.ini" {
          Browser.Enabled = true;
          GUI.ApplicationTheme = gui.style.polarity;
          Security.Security_HideNotes = true;

          PasswordGenerator = {
            Length = 128;
            LowerCase = true;
            UpperCase = true;
            SpecialChars = true;
          };
        };
      }];
    })
  ];
}
