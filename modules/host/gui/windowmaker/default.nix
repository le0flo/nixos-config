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

  cfg = config.hostConfig.gui.windowmaker;
  gnustepDir = "GNUstep/Defaults";

  fixText = path: replaceStrings
    [ "*windowmaker*" ]
    [ "${pkgs.windowmaker}" ]
    (readFile path);
in {
  options.hostConfig.gui.windowmaker.enable = mkBoolOption "Windowmaker window manager" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-windowmaker" = "startx ~/${gnustepDir}/start.sh";
      systemPackages = with pkgs; [
        dockapps.cputnik
        dockapps.wmacpi
        dockapps.wmclockmon
        dockapps.wmnd
        dockapps.wmpulsemixer
        dockapps.wmsystemtray

        gap.terminal
        gap.gnumail
      ];
    };

    hostConfig.hjem = [{
      files = {
        "${gnustepDir}/start.sh" = configSource ./start.sh;
        "${gnustepDir}/Terminal.plist" = configSource ./Terminal.plist;
        "${gnustepDir}/WindowMaker" = configText (fixText ./WindowMaker);
        "${gnustepDir}/WMRootMenu" = configText (fixText ./WMRootMenu);
      };
    }];

    services.xserver.windowManager.windowmaker.enable = true;

    xdg.portal = {
      config."windowmaker".default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
