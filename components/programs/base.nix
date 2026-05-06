{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tmux
    htop
    vim
    ascii
    file
    psmisc
    dysk
    zip
    unzip

    home-manager
  ];
}
