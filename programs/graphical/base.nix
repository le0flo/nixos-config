{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    alacritty
    localsend
    keepassxc
    veracrypt

    wl-clipboard
  ];
}
