{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tmux
    htop
    vim

    ascii
    file
    ffmpeg
    home-manager
  ];
}
