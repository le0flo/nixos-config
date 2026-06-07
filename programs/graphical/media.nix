{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    imagemagick
    ffmpeg

    vlc
    strawberry
    kid3

    gpu-screen-recorder
    gpu-screen-recorder-gtk
  ];
}
