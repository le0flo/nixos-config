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
in {
  options.hostConfig.gui.hyprland.enable = mkBoolOption "Hyprland window manager" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      foot
      mako
      nwg-panel
      playerctl
      (scripts.override { withGui = true; })
      swaybg
      swayidle
      waylock
      wmenu
    ];

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

            colors-dark.alpha = 0.7;
            colors-light.alpha = 0.7;
          };

          "hypr/hyprland.lua" = configText ''
          ${concatStringsSep "\n" (map (x: "require(\"${removeSuffix ".lua" x}\")") configHyprFiles)}

          hl.env("HYPRCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("HYPRCURSOR_THEME", "${style.cursor.name}")
          hl.env("XCURSOR_SIZE", "${toString style.cursor.size}")
          hl.env("XCURSOR_THEME", "${style.cursor.name}")
          '';

          "mako/config" = configFmt pkgs.formats.iniWithGlobalSection "config" {
            globalSection = {
              actions = true;
              ignore-timeout = false;
              default-timeout = 10000;

              background-color = "#313131";
              text-color = "#efefef";
              border-color = "#ff0000";

              outer-margin = 0;
              margin = 0;
              border-size = 1;
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
      xwayland.enable = true;
    };

    security.pam.services."waylock".enable = true;

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
