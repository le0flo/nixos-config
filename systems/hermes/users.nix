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
      ../../configs/emacs.nix
      ../../configs/fastfetch.nix
      ../../configs/foot.nix
      ../../configs/fuzzel.nix
      ../../configs/git.nix
      ../../configs/gtk.nix
      ../../configs/keepassxc.nix
      ../../configs/mako.nix
      ../../configs/niri.nix
      ../../configs/qt.nix
      ../../configs/swaylock.nix
      ../../configs/tmux.nix
      ../../configs/wallpaper.nix
      ../../configs/windowmaker.nix
      ../../configs/xresources.nix
    ];
  };
}
