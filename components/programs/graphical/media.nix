{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    imagemagick
    ffmpeg

    vlc
    strawberry
    kid3
  ];
}
