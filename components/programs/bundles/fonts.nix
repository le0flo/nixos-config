{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.iosevka-term
    nerd-fonts.jetbrains-mono

    corefonts
    vista-fonts
  ];
}
