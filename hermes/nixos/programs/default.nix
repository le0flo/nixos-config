{inputs, pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./cybersec.nix
    ./games.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    firefox thunderbird keepassxc kdePackages.kleopatra veracrypt
    electrum feather
    vlc ffmpeg yt-dlp
    alacritty zed-editor tmux vim
    nil nixd
    openssh rsync wireguard-tools
    exfat ntfs3g
    fastfetch btop

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

  # Zsh
  programs.zsh.enable = true;

  # Git
  programs.git = {
    enable = true;

    config = {
      init = {
        defaultBranch = "master";
      };
      core = {
        editor = "vim";
      };
    };
  };

  # GPG
  programs.gnupg.agent.enable = true;

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
  fonts.enable = true;
  cybersec.enable = true;
  games.enable = true;
}
