{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    zed-editor

    librewolf
    thunderbird
    feather

    keepassxc
    veracrypt

    vlc
  ];
}
