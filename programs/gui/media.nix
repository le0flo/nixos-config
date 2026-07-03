{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    inkscape
    krita
    vlc
    strawberry
    kid3
  ];
}
