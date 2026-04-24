{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    localsend
    qbittorrent
    nicotine-plus
    metadata-cleaner
  ];
}
