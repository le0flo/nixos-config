{pkgs, ...}: {
  imports = [
    ./niri.nix
    ./kde.nix
  ];

  xdg.dataFile = {
    "icons/Papirus-Dark".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark";
    "icons/Papirus-Light".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Light";
    "icons/Papirus".source = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
    "icons/Adwaita".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
  };

  stylix = {
    icons = {
      enable = true;

      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 20;
    };

    targets.qt.enable = false;
    targets.zed.enable = false;
  };

  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;

    platformTheme = {
      package = with pkgs.kdePackages; [ plasma-integration breeze ];
      name = "kde";
    };

    style = {
      package = pkgs.kdePackages.breeze;
      name = "breeze";
    };
  };
}
