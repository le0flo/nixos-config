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
  imports = [
    ./niri.nix
    ./style.nix
    ./windowmaker.nix
  ];

  options.otis.gui =
    let
      mkPkgOption = description: default: mkOption {
        inherit description default;
        type = types.package;
      };
    in {
      enable = mkEnableOption "Enable gui for a host system";

      fonts = mkOption {
        type = with types; listOf package;
        description = "Fonts to include in the system";
        default = with pkgs; [
          dejavu_fonts
          liberation_ttf
          noto-fonts
          nerd-fonts.comic-shanns-mono
          nerd-fonts.iosevka
        ];
      };

      alacritty.config = mkOption {
        type = types.attrs;
        description = "Configuration values for alacritty";
        default = {
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
      };
    };

  config =
    let
      gui = config.otis.gui;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);
    in mkIf gui.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [
          alacritty
          rofi
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
      }
    ]
    ++ forEachUser {
      xdg.config.files."alacritty/alacritty.toml" = {
        type = "copy";
        permissions = "644";

        generator = (pkgs.formats.toml {}).generate "alacritty.toml";
        value = gui.alacritty.config;
      };
    });
}
