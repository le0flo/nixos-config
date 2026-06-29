{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    vis
    tmux
    htop
    file
    tree
    psmisc
    fastfetch
  ];
}
