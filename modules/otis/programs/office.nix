{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;
in {
  options.otis.programs.office = {
    enable = mkEnableOption "Add office related programs";

    texlivePlugins = mkOption {
      type = with types; listOf package;
      description = "List of texlive plugins";
      default = with pkgs.texlivePackages; [
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
      ];
    };
  };

  config =
    let
      office = config.otis.programs.office;
      gui = config.otis.gui;
    in mkIf office.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [
          (texliveBasic.withPackages (ps: office.texlivePlugins))
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
