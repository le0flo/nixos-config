{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    substring;

  inherit (config.otis.gui) style;

  inherit (customLibs.cake.hjem)
    configFmt
    configText
    getConfigFiles;

  inherit (customLibs.cake.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge;

  cfg = config.otis.gui.niri;
  configFiles = getConfigFiles ./niri ".kdl";
in {
  options.otis.gui.niri = {
    enable = mkBoolOption "Niri window manager" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-niri" = "niri-session";
      systemPackages = with pkgs; [ xwayland-satellite ] ++ cfg.extraPackages;
    };

    otis.hjem = [{
      xdg.config.files = mkMerge [
        {
          "niri/config.kdl" = configText ''
          ${concatStringsSep "\n" (map (x: "include \"${x}\"") configFiles)}

          binds { Mod+B { spawn "${pkgs.scripts}/bin/bg-picker"; }; }

          cursor {
            xcursor-theme "${style.cursor.name}"
            xcursor-size ${toString style.cursor.size}

            hide-when-typing
          }

          layout {
            border {
              active-color "${style.colors.border}"
              inactive-color "${style.colors.background}"
              urgent-color "${style.colors.text}"
            }
          }
          '';
        }
        (genAttrs configFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./niri/${file};
          target = "niri/${file}";
        }))
      ];
    }];

    programs = {
      niri = {
        enable = true;
        useNautilus = false;
      };
    };

    xdg.portal.configPackages = [ pkgs.niri ];
  };
}
