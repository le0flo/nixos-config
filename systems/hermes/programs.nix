{pkgs, ...}: {
  imports = [
    ../../components/programs/bash.nix

    ../../components/programs/base.nix
    ../../components/programs/internet.nix
    ../../components/programs/external.nix

    ../../components/programs/graphical/base.nix
    ../../components/programs/graphical/dev.nix
    ../../components/programs/graphical/media.nix
    ../../components/programs/graphical/office.nix
    ../../components/programs/graphical/games.nix
    ../../components/programs/graphical/file-sharing.nix
    ../../components/programs/graphical/social.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    openfortivpn
    opencode
  ];

  # AppImage & Dynamic linking
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld.enable = true;
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
}
