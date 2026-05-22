{pkgs, ...}:

{
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
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
      ../../configs/niri

      ../../configs/alacritty.nix
      ../../configs/fastfetch.nix
      ../../configs/fuzzel.nix
      ../../configs/git.nix
      ../../configs/mako.nix
      ../../configs/swaylock.nix
      ../../configs/tmux.nix
      ../../configs/wallpaper.nix
      ../../configs/zed.nix
    ];
  };
}
