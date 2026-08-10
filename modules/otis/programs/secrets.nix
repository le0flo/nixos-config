{config, lib, pkgs, ...}:

let
  inherit (builtins) attrNames;

  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.programs.secrets.keepassxc.config = mkOption {
    type = types.attrs;
    description = "Config values for KeePassXC";
    default = {
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
  
  config =
    let
      secrets = config.otis.programs.secrets;
      gui = config.otis.gui;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);
    in mkMerge [
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
      })
    ]
    ++ forEachUser mkIf gui.enable {
      xdg.config.files."keepassxc/keepassxc.ini" = {
        type = "copy";
        permissions = "644";

        generator = (pkgs.formats.ini {}).generate "keepassxc.ini";
        value = secrets.keepassxc.config;
      };
    };
}
