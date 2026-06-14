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
    "niri/config.kdl" = copyText ''
      include "autostart.kdl"
      include "binds.kdl"
      include "inputs.kdl"
      include "looks.kdl"
      include "monitors.kdl"
      include "rules.kdl"

      include "colors.kdl" optional=true
      include "cursor.kdl" optional=true

      prefer-no-csd

      hotkey-overlay {
        skip-at-startup
        hide-not-bound
      }

      screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

      environment {
        QT_QPA_PLATFORM "wayland"
        QT_QPA_PLATFORMTHEME "kde"
      }
    '';

    "niri/colors.kdl" = copyText ''
      layout {
        border {
          active-color "${style.colors.border}"
          inactive-color "${style.colors.background}"
          urgent-color "${style.colors.text}"
        }
      }
    '';

    "niri/cursor.kdl" = copyText ''
      cursor {
        xcursor-theme "${style.cursor.name}"
        xcursor-size ${builtins.toString style.cursor.size}
      }
    '';

    "niri/autostart.kdl" = copySource ./niri/autostart.kdl;
    "niri/binds.kdl" = copySource ./niri/binds.kdl;
    "niri/inputs.kdl" = copySource ./niri/inputs.kdl;
    "niri/looks.kdl" = copySource ./niri/looks.kdl;
    "niri/monitors.kdl" = copySource ./niri/monitors.kdl;
    "niri/rules.kdl" = copySource ./niri/rules.kdl;
  };
}
