{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    zapzap
    telegram-desktop
    discord
    dino
  ];
}
