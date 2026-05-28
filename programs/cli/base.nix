{pkgs, ...}:

{
  nixpkgs.overlays = [
    (final: prev: {
      vim = prev.vim.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          rm -f $out/share/applications/gvim.desktop
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    vim
    tmux
    htop
    ascii
    file
    tree
    psmisc
    dysk
    zip
    unzip
    fastfetch
  ];
}
