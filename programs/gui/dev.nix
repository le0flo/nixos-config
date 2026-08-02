{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    tree-sitter
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        auctex
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
      ]
    ))
  ];
}

