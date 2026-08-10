{config, inputs, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    readDir
    replaceStrings;
  
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.gui.windowmaker =
    let
      mkPkgsOption = description: default: mkOption {
        inherit description default;
        type = types.listOf types.package;
      };
    in {
      enable = mkEnableOption "Install the windowmaker window manager";

      dockapps = mkPkgsOption
        "Dockapps for windowmaker"
        with pkgs.dockapps; [
          cputnik
          wmacpi
          wmclockmon
          wmnd
          wmpulsemixer
          wmsystemtray
        ];

      extraPackages = mkPkgsOption "Additional packages" [];
    };

  config =
    let
      windowmaker = config.otis.gui.windowmaker;
      system = config.nixpkgs.hostPlatform.system;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);
      
      gnustepDir = "GNUstep/Defaults";
  
      copyText = text: {
        inherit text;

        type = "copy";
        permissions = "644";
      };
    in mkIf windowmaker.enable mkMerge [
      {
        environment = {
          shellAliases."start-windowmaker" = "startx ~/GNUstep/Defaults/WMStart.sh";

          systemPackages = dockapps ++ extraPackages;
        };

        nixpkgs.overlays = [ inputs.gnustep.overlays.${system} ];

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
      }
    ]
    ++ forEachUser {
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
    };
}
