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
in {
  options.otis.programs.dev = {
    enable = mkEnableOption "Add development programs";
    virt-manager = mkEnableOption "Enables virt-manager";
    
    emacsPlugins = mkOption {
      type = with types; listOf package;
      description = "List of emacs plugins";
      default = with pkgs.emacsPackages; [
        auctex
        bnf-mode
        colorful-mode
        csv-mode
        dart-mode
        dockerfile-mode
        git-modes
        json-mode
        kdl-mode
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
      ];
    };
  };

  config =
    let
      dev = config.otis.programs.dev;
      gui = config.otis.gui;

      forEachUser = attrs: map (x: { hjem.users."${x}" = attrs; }) (attrNames config.hjem.users);

      configFiles = filter
        (x: hasSuffix ".el" x)
        (attrNames (readDir ./emacs));

      copyText = text: {
        inherit text;
        type = "copy";
        permissions = "644";
      };
    in mkIf dev.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [
          gnumake
          postgresql
          sqlite
          kubectl
          kubernetes-helm
        ];

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
          ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: dev.emacsPlugins))
        ];
      })
      (mkIf (gui.enable && dev.virt-manager) {
        programs.virt-manager.enable = true;

        virtualisation = {
          libvirtd.enable = true;
          spiceUSBRedirection.enable = true;
        };
      })
    ]
    ++ forEachUser (mkIf gui.enable {
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
    }));
}
