{config, lib, pkgs, ...}:

let
  inherit (builtins)
    attrNames
    filter
    readDir;

  inherit (lib)
    genAttrs
    hasSuffix
    join
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types;

  dev = config.otis.programs.dev;
  gui = config.otis.gui;

  configFiles = filter
    (x: hasSuffix ".el" x)
    (attrNames (readDir ./emacs));

  copyText = text: {
    inherit text;
    type = "copy";
    permissions = "644";
  };
in {
  options.otis.programs.dev = {
    enable = mkEnableOption "Add development programs";
    virt-manager = mkEnableOption "Enables virt-manager";

    extraEmacsPlugins = mkOption {
      type = with types; listOf package;
      description = "List of emacs plugins";
      default = [];
    };
  };

  config = mkIf dev.enable (mkMerge [
    {
      environment = {
        shellAliases."k" = "${pkgs.scripts}/bin/kubectl-wrapper";
        
        systemPackages = with pkgs; [
          gnumake
          postgresql
          sqlite
          openssl
          kubectl
          kubernetes-helm
          scripts
        ];
      };

      programs.git = {
        enable = true;

        config = {
          core.editor = "nano";
          init.defaultBranch = "master";
        };
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        tree-sitter
        ungoogled-chromium
        heidisql
        ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: with epkgs; [
          auctex
          bnf-mode
          colorful-mode
          csv-mode
          dart-mode
          dockerfile-mode
          git-modes
          json-mode
          kirigami
          lua-mode
          magit
          markdown-mode
          nginx-mode
          nix-mode
          rfc-mode
          rust-mode
          sass-mode
          typescript-mode
          web-mode
          yaml-mode
          zig-mode
        ]
        ++ dev.extraEmacsPlugins))
      ];

      otis.hjem = [
        {
          xdg.config.files = mkMerge [
            {
              "emacs/init.el" = copyText ''
                ;; Includes
                ${join "\n" (map (x: "(load-file \"~/.config/emacs/${x}\")") configFiles)}

                ;; Custom file
                (setq custom-file "~/.config/emacs/custom.el")
                (load-file custom-file)
              '';

              "emacs/custom.el" = copyText "";
            }
            (genAttrs configFiles (file: {
              type = "copy";
              permissions = "644";

              source = ./emacs/${file};
              target = "emacs/${file}";
            }))
          ];
        }
      ];
    })
    (mkIf (gui.enable && dev.virt-manager) {
      programs.virt-manager.enable = true;

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    })
  ]);
}
