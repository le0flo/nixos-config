{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  fun = config.otis.programs.fun;
in {
  options.otis.programs.fun.enable = mkEnableOption "Add fun programs :D";

  config = mkIf fun.enable {
    environment.systemPackages = with pkgs; [
      fastfetch
      cmatrix
      cowsay
    ];

    otis.hjem = [
      {
        xdg.config.files."fastfetch/config.jsonc" = {
          type = "copy";
          permissions = "644";

          generator = (pkgs.formats.json {}).generate "config.jsonc";
          value = {
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
      }
    ];
  };
}
