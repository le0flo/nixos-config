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
