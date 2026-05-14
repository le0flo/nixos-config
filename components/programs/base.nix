{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (vim.override { guiSupport = null; })
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
