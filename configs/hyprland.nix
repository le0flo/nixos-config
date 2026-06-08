{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  copyText = text: {
    inherit text;
    type = "copy";
    permissions = "664";
  };
  copySource = source: {
    inherit source;
    type = "copy";
    permissions = "664";
  };
in {
  xdg.config.files = {
    "hypr/hyprland.lua" = copyText ''
      require("autostart")
      require("binds")
      require("inputs")
      require("looks")
      require("monitors")
      require("rules")

      require("cursor")

      hl.config({
          misc = {
              force_default_wallpaper = 0,
              disable_hyprland_logo = true,
              focus_on_activate = true,
          },
      })
    '';

    "hypr/colors.lua" = copyText ''
      return {
        border_active = "${style.colors.border}",
        border_inactive = "${style.colors.background}",
      }
    '';

    "hypr/cursor.lua" = copyText ''
      hl.env("XCURSOR_THEME", "${style.cursor.name}")
      hl.env("XCURSOR_SIZE", "${builtins.toString style.cursor.size}")
      hl.env("HYPRCURSOR_THEME", "${style.cursor.name}")
      hl.env("HYPRCURSOR_SIZE", "${builtins.toString style.cursor.size}")
    '';

    "hypr/autostart.lua" = copySource ./hyprland/autostart.lua;
    "hypr/binds.lua" = copySource ./hyprland/binds.lua;
    "hypr/inputs.lua" = copySource ./hyprland/inputs.lua;
    "hypr/looks.lua" = copySource ./hyprland/looks.lua;
    "hypr/monitors.lua" = copySource ./hyprland/monitors.lua;
    "hypr/rules.lua" = copySource ./hyprland/rules.lua;

    "hypr/.luarc.json" = {
      type = "copy";
      permissions = "664";

      generator = (pkgs.formats.json {}).generate ".luarc.json";
      value = {
        diagnostics.globals = [ "hl" ];
        workspace.library = [ "\${env:HOME}/.config/hypr/hl.meta.lua" ];
      };
    };
    "hypr/hl.meta.lua" = copySource "${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua";
  };
}
