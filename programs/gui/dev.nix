{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        auctex
        colorful-mode
        csv-mode
        dart-mode
        dockerfile-mode
        emacsql
        erc
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
    ))
  ];
}

