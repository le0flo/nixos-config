{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    imagemagick
    ffmpeg

    inkscape
    krita
    vlc
    strawberry
    kid3
  ];
}
