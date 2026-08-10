{config, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    filter
    readDir;
  
  inherit (lib)
    genAttrs
    hasSuffix
    join
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.gui.niri = {
    enable = mkEnableOption "Install the niri compositor";

    extraPackages = mkOption {
      type = types.listOf types.package;
      description = "Additional packages";
      default = with pkgs; [
        pavucontrol
        ristretto
      ];
    };
  };

  config =
    let
      niri = config.otis.gui.niri;
      style = config.otis.gui.style;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);

      configFiles = filter
        (x: hasSuffix ".kdl" x)
        (attrNames (readDir ./niri));
    in mkIf niri.enable mkMerge [
      {
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
          ]
          ++ niri.extraPackages;
        };

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

        xdg.portal.configPackages = with pkgs; [ niri ];
      }
    ]
    ++ forEachUser {
      xdg.config.files = mkMerge [
        {
          "niri/config.kdl" = {
            type = "copy";
            permissions = "644";

            text = ''
              ${join "\n" (map (x: "include \"${x}\"") configFiles)}

              layout {
                border {
                  active-color "${style.colors.border}"
                  inactive-color "${style.colors.background}"
                  urgent-color "${style.colors.text}"
                }
              }

              cursor {
                xcursor-theme "${style.cursor.name}"
                xcursor-size ${toString style.cursor.size}

                hide-when-typing
              }
            '';
          };

          "mako/config" = {
            type = "copy";
            permissions = "644";

            generator = (pkgs.formats.iniWithGlobalSection {}).generate "config";
            value = {
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
          };

          "swaylock/config" = {
            type = "copy";
            permissions = "644";

            text =  ''
              ignore-empty-password
              show-failed-attempts

              indicator-idle-visible
              indicator-radius=100

              line-uses-inside

              clock
              timestr=%H:%M:%S
              datestr=%d %B

              image=${config.xdg.data.directory}/backgrounds/default
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
        }
        (genAttrs configFiles (file: {
          type = "copy";
          permissions = "644";

          source = ./niri/${file};
          target = "niri/${file}";
        }))
      ];
    };
}
