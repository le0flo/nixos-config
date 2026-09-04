{config, customLibs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    substring;

  inherit (config.otis.gui) style;

  inherit (customLibs.otis.hjem)
    configFmt
    configText
    getConfigFiles;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge;

  cfg = config.otis.gui.niri;
  configFiles = getConfigFiles ./niri ".kdl";

  parseColor = color: substring 1 6 color;
in {
  options.otis.gui.niri = {
    enable = mkBoolOption "Install the niri compositor" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-niri" = "uwsm start niri.desktop";

      systemPackages = with pkgs; [
        swaybg
        swaylock-effects
        swayidle
        mako
        playerctl
        brightnessctl
        xwayland-satellite
        pavucontrol
        ristretto
      ]
      ++ cfg.extraPackages;
    };

    otis.hjem = [
      {
        xdg.config.files = mkMerge [
          {
            "niri/config.kdl" = configText ''
            ${concatStringsSep "\n" (map (x: "include \"${x}\"") configFiles)}

            binds { Mod+B { spawn "${pkgs.scripts}/bin/bg-picker"; }; }

            cursor {
              xcursor-theme "${style.cursor.name}"
              xcursor-size ${toString style.cursor.size}

              hide-when-typing
            }

            layout {
              border {
                active-color "${style.colors.border}"
                inactive-color "${style.colors.background}"
                urgent-color "${style.colors.text}"
              }
            }
            '';

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
          }
          (genAttrs configFiles (file: {
            type = "copy";
            permissions = "644";
            source = ./niri/${file};
            target = "niri/${file}";
          }))
        ];
      }
    ];

    programs = {
      niri = {
        enable = true;
        useNautilus = false;
      };

      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-shares-plugin
          thunar-volman
        ];
      };
    };

    xdg.portal.configPackages = [ pkgs.niri ];
  };
}
