{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    nano
    tmux
    htop
    file
    tree
    psmisc
    fastfetch
    agenix-cli
  ];
}
