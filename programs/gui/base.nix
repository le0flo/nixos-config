{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    wl-clipboard
    foot
    cool-retro-term
  ];
}
