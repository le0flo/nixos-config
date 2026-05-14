{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    tmux
    htop
    ascii
    file
    psmisc
    dysk
    zip
    unzip

    home-manager
  ];
}
