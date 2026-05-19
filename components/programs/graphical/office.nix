{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    libreoffice
    calibre

    xournalpp
    krita
    inkscape
  ];
}
