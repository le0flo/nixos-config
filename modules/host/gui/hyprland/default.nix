{config, customLib, inputs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    substring;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.hostConfig.gui) style;

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

  cfg = config.hostConfig.gui.hyprland;
  hyprPkgs = inputs.hyprland.packages."${system}";
  hyprPkgsUnstable = inputs.hyprland.inputs.nixpkgs.legacyPackages."${system}";

  configHyprFiles = getConfigFiles ./. ".lua";

  parseColor = color: substring 1 6 color;
in {
  options.hostConfig.gui.hyprland.enable = mkBoolOption "Hyprland window manager" false;

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-hyprland" = "uwsm start hyprland.desktop";
      systemPackages = with pkgs; [
        brightnessctl
        foot
        fuzzel
        mako
        nwg-panel
        playerctl
        (scripts.override { withGui = true; })
        swaybg
        swayidle
        swaylock
      ];
    };

    hardware.graphics = {
      package = hyprPkgsUnstable.mesa;
      enable32Bit = true;
      package32 = hyprPkgsUnstable.pkgsi686Linux.mesa;
    };

    hostConfig.hjem = [{
      xdg.config.files = mkMerge [
        {
          "foot/foot.ini" = configFmt pkgs.formats.ini "foot.ini" {
            main = {
              term = "xterm-256color";
              pad = "5x5";
              font = "Iosevka NFM:size=16";
            };
          };

          "fuzzel/fuzzel.ini" = configFmt pkgs.formats.ini "fuzzel.ini" {
            main = {
              width = 80;
              lines = 7;

              namespace = "fuzzel";
              prompt = ''"search: "'';
              icons-enabled = false;

              horizontal-pad = 10;
              vertical-pad = 10;
              inner-pad = 10;

              terminal = "${pkgs.foot}/bin/foot -a '{cmd}' -T '{cmd}' '{cmd}'";
              font = "Iosevka NFM:size=10";
              dpi-aware = "yes";
            };

            border = {
              width = 2;
              radius = 0;
            };

            colors = {
              border = "${style.colors.primary}ff";
              background = "${style.colors.background}ff";
              text = "${style.colors.text}ff";

              prompt = "${style.colors.primary}ff";
              input = "${style.colors.secondary}ff";

              selection = "${style.colors.text}ff";
              selection-text = "${style.colors.background}ff";

              match = "${style.colors.primary}ff";
              selection-match = "${style.colors.primary}ff";
            };
          };

          "hypr/hyprland.lua" = configText ''
          ${concatStringsSep "\n" (map (x: "require(\"${removeSuffix ".lua" x}\")") configHyprFiles)}

          hl.env("HYPRCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("HYPRCURSOR_THEME", "${style.cursor.name}")
          hl.env("XCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("XCURSOR_THEME", "${style.cursor.name}")

          hl.config({ general = { col = {
             active_border = "rgba(${parseColor style.colors.primary}ff)",
             inactive_border = "rgba(${parseColor style.colors.background}ff)",
          } } })
          '';

          "mako/config" = configFmt pkgs.formats.iniWithGlobalSection "config" {
            globalSection = {
              actions = true;
              ignore-timeout = false;
              default-timeout = 10000;

              background-color = style.colors.background;
              text-color = style.colors.text;
              border-color = style.colors.primary;

              outer-margin = 0;
              margin = 5;
            };
          };
        }
        (genAttrs configHyprFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./${file};
          target = "hypr/${file}";
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
      };

      extraPortals = [
        hyprPkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
