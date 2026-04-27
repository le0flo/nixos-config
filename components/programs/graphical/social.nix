{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zapzap
    telegram-desktop
    vesktop
    weechat
  ];
}
