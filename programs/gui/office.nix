{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    atril
    collabora-desktop
    xournalpp
    gnucash

    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-basic
        metafont titling setspace xcolor hyperref
        amsfonts amsmath amstex
        tikz-ext tikz-3dplot;
    })
  ];
}
