{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.office;
in {
  options.otis.programs.office.enable = mkBoolOption "Office" false;

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        pandoc
        (texliveBasic.withPackages (ps: with ps; [
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
          booktabs
          footnotehyper
        ]))
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        atril
        libreoffice
        xournalpp
        gnucash
      ];
    })
  ]);
}
