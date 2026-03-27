{inputs, pkgs, ...}: {
  imports = [
    ../../components/programs/git.nix
    ../../components/programs/fonts.nix
    ../../components/programs/games.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # CLI tools
    wget dig ascii file fastfetch eza btop dysk

    # Remote tools
    openssh rsync wireguard-tools kubectl

    # Coding
    tmux vim alacritty emacs zed-editor claude-code opencode
    nil nixd

    # External devices
    exfat ntfs3g android-tools

    # Internet
    librewolf thunderbird feather

    # Secret management
    keepassxc veracrypt

    # Media
    vlc ffmpeg yt-dlp
    gpu-screen-recorder gpu-screen-recorder-gtk

    # Home manager
    inputs.home-manager.packages.${stdenv.hostPlatform.system}.home-manager

    # Custom packages
    inputs.obdautodoctor-nix.packages.${stdenv.hostPlatform.system}.default
  ];

  # Nix linker
  programs.nix-ld.enable = true;

  # AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Virtualisation
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  users.extraGroups = {
    "docker".members = [ "leo" ];
    "libvirtd".members = [ "leo" ];
  };

  programs.virt-manager.enable = true;

  # Custom modules
  git.enable = true;
  fonts.enable = true;
  games.enable = true;
}
