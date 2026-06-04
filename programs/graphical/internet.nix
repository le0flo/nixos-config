{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    librewolf
    thunderbird

    qbittorrent
    nicotine-plus

    newsflash
    telegram-desktop
    discord
  ];
}
