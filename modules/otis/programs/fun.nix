{config, lib, pkgs, ...}:

let
  inherit (builtins) attrNames;

  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.programs.fun = {
    enable = mkEnableOption "Add fun programs :D";

    fastfetch.config = mkOption {
      type = types.attrs;
      description = "Config values for fastfetch";
      default = {
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
    };

  config =
    let
      fun = config.otis.programs.fun;
      
      forEachUser = attrs: (x: { hjem.users."${x}" = attrs }) (attrNames config.hjem.users);
    in mkIf fun.enable mkMerge [
      {
        environment.systemPackages = with pkgs; [
          fastfetch
          cmatrix
          cowsay
        ];
      }
    ]
    ++ forEachUser {
      xdg.config.files."fastfetch/config.jsonc" = {
        type = "copy";
        permissions = "644";

        generator = (pkgs.formats.json {}).generate "config.jsonc";
        value = fun.fastfetch.config;
      };
    };
}
