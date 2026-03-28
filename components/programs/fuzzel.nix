{lib, config, pkgs, ...}: {
  options.fuzzel.enable = lib.mkEnableOption "Fuzzel";

  config = lib.mkIf config.fuzzel.enable {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          prompt = "search: ";
          icons-enabled = false;

          terminal = "${pkgs.alacritty}/bin/alacritty -e";
          font = "IosevkaTerm NF:style=regular:size=12";
          layer = "overlay";
        };

        colors = {
          background = "505050ff";
          text = "fafafaff";

          prompt = "ccd5aeff";
          input = "ccd5aeff";
          match = "e6e6e6ff";

          selection = "ccd5aeff";
          selection-text = "606060ff";
          selection-match = "101010ff";

          border = "ccd5aeff";
        };

        border = {
          width = 2;
          radius = 0;
        };
      };
    };
  };
}
