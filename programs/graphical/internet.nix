{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    librewolf
    thunderbird
    liferea

    qbittorrent
    nicotine-plus

    telegram-desktop
    vesktop
  ];
}
