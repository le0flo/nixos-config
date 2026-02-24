{inputs, pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./games.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    librewolf thunderbird
    keepassxc veracrypt kdePackages.kleopatra
    electrum feather
    vlc ffmpeg yt-dlp

    openssh rsync wireguard-tools dig
    alacritty zed-editor tmux vim
    nil nixd

    ascii file fastfetch btop dysk
    exfat ntfs3g android-tools

    claude-code

    # Home manager
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager

    # DBmain
    inputs.dbmain-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
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
