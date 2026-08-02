{pkgs, ...}:

{
  imports = [ ./base.nix ];

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  xdg.portal.configPackages = with pkgs; [ niri ];

  environment.shellAliases."start-niri" = "uwsm start niri.desktop";
}
