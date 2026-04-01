{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tmux
    htop
    vim

    ascii
    file
    dysk
    ffmpeg
    home-manager
  ];
}
