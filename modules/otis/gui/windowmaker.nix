{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;

  inherit (customLibs.otis.hjem)
    configSource
    configText;

  inherit (customLibs.otis.opts)
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
    enable = mkBoolOption "Install the windowmaker window manager" false;
    dockapps = mkPkgsOption "Dockapps for windowmaker" (with pkgs.dockapps; [
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
