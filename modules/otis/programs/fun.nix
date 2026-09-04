{config, customLibs, lib, pkgs, ...}:

let
  inherit (customLibs.otis.hjem) configFmt;

  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.programs.fun;
in {
  options.otis.programs.fun.enable = mkBoolOption "Add fun programs :D" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fastfetch
      cmatrix
      cowsay
    ];

    otis.hjem = [{
      xdg.config.files."fastfetch/config.jsonc" = configFmt pkgs.formats.json "config.jsonc" {
        logo = {
          source = "linux";
          padding.right = 1;
        };

        display = {
          size = {
            maxPrefix = "MB";
            ndigits = 0;
            spaceBeforeUnit = "never";
          };
          freq = {
            ndigits = 3;
            spaceBeforeUnit = "never";
          };
        };

        modules = [
          "title"
          "separator"
          "os"
          {
            type = "kernel";
            format = "{release}";
          }
          {
            type = "packages";
            combined = true;
          }
          "shell"
          {
            type = "display";
            compactType = "original";
            key = "Resolution";
          }
          "de"
          "wm"
          "terminal"
          "cpu"
          {
            type = "gpu";
            key = "GPU";
            format = "{name}";
          }
          {
            type = "memory";
            format = "{used} / {total}";
          }
          "break"
          "colors"
        ];
      };
    }];
  };
}
