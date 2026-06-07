{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    vis
    tmux
    htop
    ascii
    file
    tree
    psmisc
    dysk
    zip
    unzip
    gnutar
    fastfetch
  ];
}
