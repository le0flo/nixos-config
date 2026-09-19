{config, customLib, inputs, lib, pkgs, ...}:

let
  inherit (builtins)
    concatStringsSep
    substring;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (config.otis.gui) style;

  inherit (customLib.hjem)
    configText
    getConfigFiles;

  inherit (customLib.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge
    removeSuffix;

  cfg = config.otis.gui.hyprland;
  configFiles = getConfigFiles ./. ".lua";
  hyprPkgs = inputs.hyprland.packages."${system}";

  parseColor = color: substring 1 6 color;
in {
  options.otis.gui.hyprland = {
    enable = mkBoolOption "Hyprland window manager" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-hyprland" = "uwsm start hyprland.desktop";
      systemPackages = cfg.extraPackages;
    };

    otis.hjem = [{
      xdg.config.files = mkMerge [
        {
          "hypr/hyprland.lua" = configText ''
          ${concatStringsSep "\n" (map (x: "require(\"${removeSuffix ".lua" x}\")") configFiles)}
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
        }
        (genAttrs configFiles (file: {
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
        "org.freedesktop.impl.portal.Inhibit" = "none";
      };

      extraPortals = [
        hyprPkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
