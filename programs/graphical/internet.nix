{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    librewolf
    thunderbird
    liferea

    localsend
    qbittorrent
    nicotine-plus

    telegram-desktop
  ];
}
