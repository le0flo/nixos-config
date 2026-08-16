{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  office = config.otis.programs.office;
  gui = config.otis.gui;
in {
  options.otis.programs.office = {
    enable = mkEnableOption "Add office related programs";

    extraTexlivePlugins = mkOption {
      type = with types; listOf package;
      description = "List of texlive plugins";
      default = [];
    };
  };

  config = mkIf office.enable (mkMerge [
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
        ] ++ office.extraTexlivePlugins))
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
