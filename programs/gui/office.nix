{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    atril
    collabora-desktop
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
        amsfonts
        amsmath
        amstex
        tikz-ext
        tikz-3dplot
      ]
    ))
  ];
}
