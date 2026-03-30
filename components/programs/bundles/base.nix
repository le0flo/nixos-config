{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty

    librewolf
    thunderbird
    feather

    keepassxc
    veracrypt

    zed-editor

    vlc
  ];
}
