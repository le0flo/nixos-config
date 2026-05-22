{pkgs, ...}:

{
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
  ];
}
