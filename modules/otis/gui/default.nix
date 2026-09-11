{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins) substring;

  inherit (config.otis.gui) style;

  inherit (customLibs.cake.hjem)
    configFmt
    configText;

  inherit (customLibs.cake.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.gui;

  parseColor = color: substring 1 6 color;
in {
  imports = [
    ./hyprland.nix
    ./niri.nix
    ./plasma-bigscreen.nix
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
      brightnessctl
      mako
      pavucontrol
      playerctl
      ristretto
      rofi
      swaybg
      swayidle
      swaylock-effects
      wl-clipboard
      xclip
    ];

    fonts.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      nerd-fonts.comic-shanns-mono
      nerd-fonts.iosevka
    ] ++ cfg.extraFonts;

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
        "mako/config" = configFmt pkgs.formats.iniWithGlobalSection "config" {
          globalSection = {
            actions = true;
            ignore-timeout = false;

            background-color = style.colors.background;
            text-color = style.colors.text;
            border-color = style.colors.border;
            
            outer-margin = 0;
            margin = 5;
          };
        };
        "swaylock/config" = configText ''
        ignore-empty-password
        show-failed-attempts

        indicator-idle-visible
        indicator-radius=100

        line-uses-inside

        clock
        timestr=%H:%M:%S
        datestr=%d %B

        image=~/.local/share/wallpapers/default
        effect-blur=6x7
        color=${parseColor style.colors.background}

        inside-color=${parseColor style.colors.background}
        inside-clear-color=${parseColor style.colors.background}
        inside-caps-lock-color=${parseColor style.colors.background}
        inside-ver-color=${parseColor style.colors.background}
        inside-wrong-color=${parseColor style.colors.background}

        key-hl-color=${parseColor style.colors.primary}
        caps-lock-key-hl-color=${parseColor style.colors.primary}

        bs-hl-color=${parseColor style.colors.secondary}
        caps-lock-bs-hl-color=${parseColor style.colors.secondary}

        ring-color=${parseColor style.colors.background}
        ring-clear-color=${parseColor style.colors.background}
        ring-caps-lock-color=${parseColor style.colors.background}
        ring-ver-color=${parseColor style.colors.background}
        ring-wrong-color=${parseColor style.colors.background}

        separator-color=${parseColor style.colors.background}

        text-color=${parseColor style.colors.text}
        text-clear-color=${parseColor style.colors.text}
        text-caps-lock-color=${parseColor style.colors.text}
        text-ver-color=${parseColor style.colors.text}
        text-wrong-color=${parseColor style.colors.text}
        '';
      };
    }];

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-shares-plugin
        thunar-volman
      ];
    };

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
