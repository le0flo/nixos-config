{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;

  inherit (customLib.hjem)
    configSource
    configText;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.gui.windowmaker;
  gnustepDir = "GNUstep/Defaults";

  fixText = path: replaceStrings
    [ "*windowmaker*" ]
    [ "${pkgs.windowmaker}" ]
    (readFile path);
in {
  options.otis.gui.windowmaker.enable = mkBoolOption "Windowmaker window manager" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-windowmaker" = "startx ~/${gnustepDir}/start.sh";
      systemPackages = with pkgs.dockapps; [
        cputnik
        wmacpi
        wmclockmon
        wmnd
        wmpulsemixer
        wmsystemtray
      ];
    };

    otis.hjem = [{
      files = {
        "${gnustepDir}/start.sh" = configSource ./start.sh;
        "${gnustepDir}/WMRootMenu" = configText (fixText ./WMRootMenu);
        "${gnustepDir}/WindowMaker" = configText (fixText ./WindowMaker);
      };
    }];

    services.xserver.windowManager.windowmaker.enable = true;

    xdg.portal = {
      config."windowmaker".default = [ "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
