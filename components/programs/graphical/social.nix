{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    telegram-desktop
    discord
    zapzap
    gajim
  ];
}
