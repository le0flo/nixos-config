{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
    vlc
    strawberry
    kid3
  ];
}
