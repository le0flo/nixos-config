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

  system.activationScripts.ldd.text = ''
    mkdir -p /usr/bin
    ln -sf ${pkgs.glibc.bin}/bin/ldd /usr/bin/ldd
  '';
}
