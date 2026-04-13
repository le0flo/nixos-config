{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty

    librewolf
    thunderbird

    keepassxc
    veracrypt
  ];
}
