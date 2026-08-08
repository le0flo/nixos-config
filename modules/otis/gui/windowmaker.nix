{config, inputs, lib, pkgs, ...}:

{
  options.otis.gui.windowmaker =
    with lib;
    let
      t = types;

      mkPkgsOption = description: default: mkOption {
        inherit description default;
        type = t.listOf t.package;
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
      system = config.nixpkgs.hostPlatform.system;
      windowmaker = config.otis.gui.windowmaker;
    in lib.mkIf windowmaker.enable lib.mkMerge [
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
    ] ++ map
      (x: let
        gnustepDir = "GNUstep/Defaults";
  
        copyText = text: {
          inherit text;

          type = "copy";
          permissions = "644";
        };
      in {
        hjem.users."${x}".files = {
          "${gnustepDir}/WMStart.sh" = copyText (builtins.readFile ./windowmaker/WMStart.sh);

          "${gnustepDir}/WMRootMenu" = copyText
            (builtins.replaceStrings
              [ "*windowmaker*" ]
              [ "${pkgs.windowmaker}" ]
              (builtins.readFile ./windowmaker/WMRootMenu));

          "${gnustepDir}/WindowMaker" = copyText
            (builtins.replaceStrings
              [ "*windowmaker*" ]
              [ "${pkgs.windowmaker}" ]
              (builtins.readFile ./windowmaker/WindowMaker));
        };
      })
      (lib.attrNames config.hjem.users);
}
