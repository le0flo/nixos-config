{config, customLib, inputs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    substring;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.gui) style;

  inherit (customLib.hjem)
    configFmt
    configText
    getConfigFiles;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge
    removeSuffix;

  cfg = config.otis.gui.hyprland;
  hyprPkgs = inputs.hyprland.packages."${system}";

  configLuaFiles = getConfigFiles ./. ".lua";
  configQmlFiles = getConfigFiles ./. ".qml";

  parseColor = color: substring 1 6 color;
in {
  options.otis.gui.hyprland.enable = mkBoolOption "Hyprland window manager" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-hyprland" = "uwsm start hyprland.desktop";
      systemPackages = with pkgs; [
        grim
        mako
        quickshell
        slurp
        swaybg
        swayidle
        swaylock-effects
      ];
    };

    otis.hjem = [{
      xdg.config.files = mkMerge [
        {
          "hypr/hyprland.lua" = configText ''
          ${concatStringsSep "\n" (map (x: "require(\"${removeSuffix ".lua" x}\")") configLuaFiles)}
          hl.bind("SUPER + B", hl.dsp.exec_cmd("${pkgs.scripts}/bin/bg-picker"))

          hl.env("HYPRCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("HYPRCURSOR_THEME", "${style.cursor.name}")
          hl.env("XCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("XCURSOR_THEME", "${style.cursor.name}")

          hl.config({ general = { col = {
             active_border = "rgba(${parseColor style.colors.border}ff)",
             inactive_border = "rgba(${parseColor style.colors.background}ff)",
          } } })
          '';

          "quickshell/config.js" = configText ''
          const colors = {
            background: "${style.colors.background}",
            text: "${style.colors.text}",
            primary: "${style.colors.primary}",
            secondary: "${style.colors.secondary}",
          };
          '';

          "mako/config" = configFmt pkgs.formats.iniWithGlobalSection "config" {
            globalSection = {
              actions = true;
              ignore-timeout = false;
              default-timeout = 10000;

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
        (genAttrs configLuaFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./${file};
          target = "hypr/${file}";
        }))
        (genAttrs configQmlFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./${file};
          target = "quickshell/${file}";
        }))
      ];
    }];

    programs.hyprland = {
      enable = true;
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };

    xdg.portal = {
      config."Hyprland" = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        "org.freedesktop.impl.portal.Inhibit" = "none";
      };

      extraPortals = [
        hyprPkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
