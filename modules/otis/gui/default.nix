{config, customLibs, lib, pkgs, ...}:

let
  inherit (customLibs.otis.hjem)
    configFmt
    configText;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.gui;
in {
  imports = [
    ./niri.nix
    ./style.nix
    ./windowmaker.nix
  ];

  options.otis.gui = {
    enable = mkBoolOption "Enable gui for a host system" false;
    extraFonts = mkPkgsOption "Additional fonts to include in the system" [];
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      rofi
      wl-clipboard
      xclip
    ];

    fonts.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      nerd-fonts.comic-shanns-mono
      nerd-fonts.iosevka
    ]
    ++ cfg.extraFonts;

    otis.hjem = [{
      xdg.config.files = {
        "alacritty/alacritty.toml" = configFmt pkgs.formats.toml "alacritty.toml" {
          window = {
            padding = {
              x = 5;
              y = 5;
            };

            opacity = 1.0;
            blur = false;
          };

          env = {
            TERM = "xterm-256color";
            WINIT_X11_SCALE_FACTOR = "1.0";
          };

          font = {
            size = 18.00;

            normal = {
              family = "ComicShannsMono Nerd Font Mono";
              style = "Regular";
            };
            bold = {
              family = "ComicShannsMono Nerd Font Mono";
              style = "Bold";
            };
          };
        };
        "rofi/config.rasi" = configText "@theme \"${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi\"";
      };
    }];

    programs.uwsm.enable = true;

    services = {
      dbus.enable = true;
      flatpak.enable = true;
      gvfs.enable = true;
      gnome.gnome-keyring.enable = true;
      libinput.enable = true;
      tumbler.enable = true;      

      xserver = {
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

        xkb.layout = "it";
      };
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
