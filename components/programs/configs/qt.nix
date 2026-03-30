{pkgs, ...}: {
  qt = {
    enable = true;

    platformTheme = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };

    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
