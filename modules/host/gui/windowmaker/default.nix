{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;

  inherit (customLib.hjem)
    configFmt
    configSource
    configSourceExe
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
  options.hostConfig.gui.windowmaker.enable = mkBoolOption "WindowMaker window manager" false;

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
        "${gnustepDir}/start.sh" = configSourceExe ./start.sh;
        "${gnustepDir}/Terminal.plist" = configSource ./Terminal.plist;
        "${gnustepDir}/WindowMaker" = configText (fixText ./WindowMaker);
        "${gnustepDir}/WMRootMenu" = configText (fixText ./WMRootMenu);
      };

      xdg.config.files."systemd/user/windowmaker-session.target" = configFmt pkgs.formats.ini "windowmaker-session.target" {
        Unit = {
          Description = "WindowMaker graphical session";
          BindsTo = "graphical-session.target";
          Wants = "graphical-session-pre.target";
          After = "graphical-session-pre.target";
        };
      };
    }];

    services.xserver.windowManager.windowmaker.enable = true;

    xdg.portal = {
      config."windowmaker".default = [ "gtk" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
