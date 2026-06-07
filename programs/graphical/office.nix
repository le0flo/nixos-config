{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    libreoffice
    calibre
    xournalpp
    inkscape
    krita
  ];
}
