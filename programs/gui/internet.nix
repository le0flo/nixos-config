{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    liferea

    localsend
    qbittorrent
    nicotine-plus
  ];
}
