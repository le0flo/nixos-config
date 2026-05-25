{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  packageDataFiles = dataDir: packages:
    pkgs.lib.pipe packages [
      (builtins.concatMap (pkg:
        pkgs.lib.mapAttrsToList (name: _: {
          name = "${dataDir}/${name}";
          value.source = "${pkg}/share/${dataDir}/${name}";
        })
        (builtins.readDir "${pkg}/share/${dataDir}")))
      builtins.listToAttrs
    ];
in {
  xdg = {
    config.files = {
      "environment.d/qt.conf".text = ''
        QT_QPA_PLATFORM=wayland
        QT_QPA_PLATFORMTHEME=kde
        QT_STYLE_OVERRIDE=${style.qt.style}
      '';

      "kdeglobals".source = pkgs.writeText "kdeglobals" ''
        ${builtins.readFile style.qt.colorSchemeFile}

        [Icons]
        Theme=${style.qt.icons}

        [KDE]
        widgetStyle=${style.qt.style}
      '';
    };

    data.files = {
      "color-schemes" = {
        type = "directory";
        permissions = "755";
      };
    }
    // packageDataFiles "color-schemes" [ style.qt.stylePackage ];
  };
}
