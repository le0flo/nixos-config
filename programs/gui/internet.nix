{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird

    localsend
    qbittorrent
    nicotine-plus
  ];
}
