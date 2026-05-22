{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    dbeaver-bin

    freecad
    kicad
  ];
}
