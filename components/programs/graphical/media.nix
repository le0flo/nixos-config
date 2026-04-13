{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    yt-dlp

    vlc
    strawberry
    kid3
  ];
}
