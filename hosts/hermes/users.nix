{pkgs, ...}:

{
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "audio"
      "dialout"
      "docker"
      "libvirtd"
      "video"
      "wheel"
    ];
  };

  hjem.users."leo" = {
    directory = "/home/leo";
    clobberFiles = true;

    imports = [
      ../../configs/alacritty.nix
      ../../configs/emacs.nix
      ../../configs/fastfetch.nix
      ../../configs/git.nix
      ../../configs/gtk.nix
      ../../configs/keepassxc.nix
      ../../configs/mako.nix
      ../../configs/niri.nix
      ../../configs/qt.nix
      ../../configs/scripts.nix
      ../../configs/swaylock.nix
      ../../configs/tmux.nix
      ../../configs/wallpaper.nix
      ../../configs/windowmaker.nix
    ];
  };
}
