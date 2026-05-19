{pkgs, ...}:

{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        prompt = "search: ";
        icons-enabled = false;
        inner-pad = 10;

        terminal = "${pkgs.alacritty}/bin/alacritty -e";
        layer = "overlay";
      };

      border = {
        width = 2;
        radius = 0;
      };
    };
  };
}
