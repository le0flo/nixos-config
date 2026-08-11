{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkIf
    mkMerge;

  secrets = config.otis.programs.secrets;
  gui = config.otis.gui;
in {  
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        rage
        ragenix
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        keepassxc
        veracrypt
      ];

      otis.hjem = [
        {
          xdg.config.files."keepassxc/keepassxc.ini" = {
            type = "copy";
            permissions = "644";

            generator = (pkgs.formats.ini {}).generate "keepassxc.ini";
            value = {
              Browser.Enabled = true;
              GUI.ApplicationTheme = config.otis.gui.style.polarity;
              Security.Security_HideNotes = true;

              PasswordGenerator = {
                Length = 128;
                LowerCase = true;
                UpperCase = true;
                SpecialChars = true;
              };
            };
          };
        }
      ];
    })
  ];
}
