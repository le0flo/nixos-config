{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zed-editor
    vscode

    dbeaver-bin

    freecad
  ];
}
