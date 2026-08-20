{config, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;
  
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types;

  windowmaker = config.otis.gui.windowmaker;
  gnustepDir = "GNUstep/Defaults";

  mkPkgsOption = description: default: mkOption {
    inherit description default;
    type = with types; listOf package;
  };

  copyText = text: {
    inherit text;

    type = "copy";
    permissions = "644";
  };
in {
  options.otis.gui.windowmaker = {
    enable = mkEnableOption "Install the windowmaker window manager";

    dockapps = mkPkgsOption
      "Dockapps for windowmaker"
      (with pkgs.dockapps; [
        cputnik
        wmacpi
        wmclockmon
        wmnd
        wmpulsemixer
        wmsystemtray
      ]);

    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf windowmaker.enable {
    environment = {
      shellAliases."start-windowmaker" = "startx ~/GNUstep/Defaults/WMStart.sh";

      systemPackages = windowmaker.dockapps ++ windowmaker.extraPackages;
    };

    otis.hjem = [
      {
        files = {
          "${gnustepDir}/WMStart.sh" = copyText (readFile ./windowmaker/WMStart.sh);

          "${gnustepDir}/WMRootMenu" = copyText
            (replaceStrings
              [ "*windowmaker*" ]
              [ "${pkgs.windowmaker}" ]
              (readFile ./windowmaker/WMRootMenu));

          "${gnustepDir}/WindowMaker" = copyText
            (replaceStrings
              [ "*windowmaker*" ]
              [ "${pkgs.windowmaker}" ]
              (readFile ./windowmaker/WindowMaker));
        };
      }
    ];

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-shares-plugin
        thunar-volman
      ];
    };

    services.xserver.windowManager.windowmaker.enable = true;

    xdg.portal = {
      config."windowmaker".default = [ "gtk" ];

      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
