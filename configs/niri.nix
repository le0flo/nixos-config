{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg = {
    config.files = {
      "niri/config.kdl".text = builtins.readFile ./niri/config.kdl;

      "niri/colors.kdl".text = ''
        layout {
          border {
            active-color "${style.colors.border}"
            inactive-color "${style.colors.background}"
            urgent-color "${style.colors.text}"
          }
        }
      '';

      "niri/cursor.kdl".text = ''
        cursor {
          xcursor-theme "${style.cursor.name}"
          xcursor-size ${builtins.toString style.cursor.size}
        }
      '';
    };

    mime-apps.default-applications = {
      "inode/directory" = "dolphin.desktop";
    };
  };
}
