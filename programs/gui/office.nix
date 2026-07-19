{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    atril
    libreoffice
    xournalpp
    gnucash

    (texliveBasic.withPackages (
      ps: with ps; [
        metafont
        titling
        setspace
        xcolor
        hyperref
        enumitem
        standalone
        filehook
        svn-prov
        amsfonts
        amsmath
        amstex
        tikz-ext
        tikz-3dplot
      ]
    ))
  ];
}
