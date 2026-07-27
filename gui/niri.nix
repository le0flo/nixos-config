{pkgs, ...}:

{
  imports = [ ./base.nix ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal.configPackages = with pkgs; [ niri ];
}
