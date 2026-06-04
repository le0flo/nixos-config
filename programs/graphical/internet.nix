{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    librewolf
    thunderbird

    qbittorrent
    nicotine-plus

    newsflash
    kdePackages.alligator
    telegram-desktop
    discord
  ];
}
