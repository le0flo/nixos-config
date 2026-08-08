{config, lib, pkgs, ...}:

{
  options.otis.gui.niri =
    with lib;
    let
      t = types;
    in {
      enable = mkEnableOption "Install the niri compositor";

      extraPackages = mkOption {
        type = t.listOf t.package;
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
    in lib.mkIf niri.enable lib.mkMerge [
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
    ] ++ map
      (x: let
        configFiles = builtins.filter
          (x: lib.hasSuffix ".kdl" x)
          (builtins.attrNames (builtins.readDir ./niri));
      in {
        hjem.users."${x}".xdg.config.files = lib.mkMerge [
          {
            "niri/config.kdl" = {
              type = "copy";
              permissions = "644";

              text = ''
                  ${lib.join "\n" (map (x: "include \"${x}\"") configFiles)}

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
          (lib.genAttrs
            configFiles
            (file: {
              type = "copy";
              permissions = "644";

              source = ./niri/${file};
              target = "niri/${file}";
            }))
        ];
      })
      (lib.attrNames config.hjem.users));
}
