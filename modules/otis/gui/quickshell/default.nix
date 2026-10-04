{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins) concatStringsSep;

  inherit (config.otis.gui) style;

  inherit (customLib.hjem)
    configText
    getConfigFiles;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge;

  cfg = config.otis.gui.quickshell;
  configFiles = getConfigFiles ./. ".qml";
in {
  options.otis.gui.quickshell.enable = mkBoolOption "Quickshell shell" false;

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quickshell ];

    otis.hjem = [{
      xdg.config.files = mkMerge [
        {
          "quickshell/config.js" = configText ''
          const colors = {
            background: "${style.colors.background}",
            text: "${style.colors.text}",
            primary: "${style.colors.primary}",
            secondary: "${style.colors.secondary}",
          };
          '';
          "hypr/quickshell.lua" = configText ''
          hl.on("hyprland.start", function()
             hl.exec_cmd("qs")
          end)
          '';
        }
        (genAttrs configFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./${file};
          target = "quickshell/${file}";
        }))
      ];
    }];
  };
}
