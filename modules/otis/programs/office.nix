{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.office;
in {
  options.otis.programs.office = {
    enable = mkBoolOption "Add office related programs" false;
    extraTexlivePlugins = mkPkgsOption "List of texlive plugins" [];
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
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
        ] ++ cfg.extraTexlivePlugins))
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
