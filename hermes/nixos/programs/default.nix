{inputs, pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./games.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    librewolf thunderbird
    keepassxc kdePackages.kleopatra veracrypt
    vlc ffmpeg yt-dlp
    alacritty zed-editor tmux vim
    nil nixd
    openssh rsync wireguard-tools dig
    ascii file fastfetch btop
    exfat ntfs3g
    electrum feather
    wine64 distrobox

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
  games.enable = true;
}
