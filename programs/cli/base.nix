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

  programs.nix-ld.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
