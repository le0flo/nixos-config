{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    chromium
    thunderbird
    liferea

    localsend
    qbittorrent
    nicotine-plus
  ];
}
