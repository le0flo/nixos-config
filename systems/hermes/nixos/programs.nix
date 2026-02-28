{inputs, pkgs, ...}: {
  imports = [
    ../../../components/programs/git.nix
    ../../../components/programs/fonts.nix
    ../../../components/programs/games.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    ascii file fastfetch eza btop dysk
    openssh rsync wireguard-tools dig
    alacritty zed-editor tmux vim claude-code
    nil nixd
    exfat ntfs3g android-tools

    # Graphical
    librewolf thunderbird keepassxc
    veracrypt feather

    # Media
    vlc ffmpeg yt-dlp
    gpu-screen-recorder gpu-screen-recorder-gtk

    # Unibo stuff
    digital
    inputs.dbmain-nix.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Home manager
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
  ];

  # Dynamic linking
  programs.nix-ld.enable = true;

  # AppImages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups."docker".members = [ "leo" ];

  # Virt manager
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  users.groups."libvirtd".members = [ "leo" ];
  programs.virt-manager.enable = true;

  # Custom
  git.enable = true;
  fonts.enable = true;
  games.enable = true;
}
