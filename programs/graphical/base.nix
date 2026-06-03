{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    alacritty
    wl-clipboard

    librewolf
    thunderbird

    keepassxc
    veracrypt

    kdePackages.alligator
  ];
}
