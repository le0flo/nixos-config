{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  configFiles = builtins.filter
    (x: lib.hasSuffix ".kdl" x)
    (builtins.attrNames (builtins.readDir ./niri));

  includeConfigs = lib.join
    "\n"
    (builtins.map
      (x: "include \"${x}\"")
      configFiles);

  packageConfigs = lib.genAttrs
    configFiles
    (file: {
      source = ./niri/${file};
      target = "niri/${file}";
      type = "copy";
      permissions = "644";
    });

  copyText = text: {
    inherit text;
    type = "copy";
    permissions = "664";
  };
in {
  xdg.config.files = {
    "niri/config.kdl" = copyText ''
      ${includeConfigs}

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
        QT_QPA_PLATFORMTHEME "qt6ct"
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

    "niri/bg-picker.sh" = {
      source = ./niri/bg-picker.sh;
      type = "copy";
      permissions = "755";
    };
  }
  // packageConfigs;
}
