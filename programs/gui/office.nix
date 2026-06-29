{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    atril
    libreoffice
    xournalpp
    gnucash
  ];
}
