{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    yt-dlp

    mpv
    strawberry
    kid3
  ];
}
