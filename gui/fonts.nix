{pkgs, ...}:

{
  fonts.packages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    noto-fonts
    nerd-fonts.comic-shanns-mono
    nerd-fonts.iosevka
  ];
}
