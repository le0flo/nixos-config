{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;

  inherit (customLibs.cake.hjem)
    configSource
    configText;

  inherit (customLibs.cake.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib) mkIf;

  cfg = config.otis.gui.windowmaker;
  gnustepDir = "GNUstep/Defaults";

  fixText = path: replaceStrings
    [ "*windowmaker*" ]
    [ "${pkgs.windowmaker}" ]
    (readFile path);
in {
  options.otis.gui.windowmaker = {
    enable = mkBoolOption "Windowmaker window manager" false;
    dockapps = mkPkgsOption "Dockapps" (with pkgs.dockapps; [
      cputnik
      wmacpi
      wmclockmon
      wmnd
      wmpulsemixer
      wmsystemtray
    ]);
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-windowmaker" = "startx ~/GNUstep/Defaults/start.sh";
      systemPackages = cfg.dockapps ++ cfg.extraPackages;
    };

    otis.hjem = [{
      files = {
        "${gnustepDir}/start.sh" = configSource ./windowmaker/start.sh;
        "${gnustepDir}/WMRootMenu" = configText (fixText ./windowmaker/WMRootMenu);
        "${gnustepDir}/WindowMaker" = configText (fixText ./windowmaker/WindowMaker);
      };
    }];

    services.xserver.windowManager.windowmaker.enable = true;

    xdg.portal = {
      config."windowmaker".default = [ "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
