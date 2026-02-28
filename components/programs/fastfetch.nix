{lib, config, ...}: {
  options.fastfetch.enable = lib.mkEnableOption "Fastfetch's config";

  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
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
  };
}
