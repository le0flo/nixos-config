{config, lib, pkgs, ...}:

{
  imports = [
    ./niri.nix
    ./style.nix
    ./windowmaker.nix
  ];

  options.otis.gui =
    with lib;
    let
      t = types;

      mkPkgOption = description: default: mkOption {
        inherit description default;
        type = t.package;
      };
    in {
      enable = mkEnableOption "Enable gui for a host system";

      terminal = mkPkgOption "The default terminal emulator" pkgs.alacritty;
      launcher = mkPkgOption "The default app launcher" pkgs.rofi;

      fonts = mkOption {
        type = t.listOf t.package;
        description = "Fonts to include in the system";
        default = with pkgs; [
          dejavu_fonts
          liberation_ttf
          noto-fonts
          nerd-fonts.comic-shanns-mono
          nerd-fonts.iosevka
        ];
      };
    };

  config =
    with lib;
    let
      gui = config.otis.gui;
    in mkIf gui.enable {
      environment.systemPackages = [
        gui.terminal
        gui.launcher
        wl-clipboard
        xclip
      ];

      fonts.packages = gui.fonts;

      programs.uwsm.enable = true;

      services.xserver = {
        enable = true;
    
        desktopManager.xterm.enable = false;
        displayManager = {
          lightdm.enable = false;
          startx.enable = true;
        };

        deviceSection = ''
          Option "TearFree" "true"
          Option "DRI" "3"
        '';
    
        videoDrivers = [ "modesetting" ];
      };

      xdg = {
        icons.enable = true;
        autostart.enable = true;

        portal = {
          enable = true;
          xdgOpenUsePortal = true;
        };
      };
    };
}
