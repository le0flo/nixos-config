{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    foot
    wl-clipboard
  ];
}
