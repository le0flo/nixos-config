{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    foot
  ];
}
