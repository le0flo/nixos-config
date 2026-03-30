{pkgs, ...}: {
  imports = [
    ../../components/programs/bundles/cli.nix
    ../../components/programs/bundles/internet.nix
    ../../components/programs/bundles/base.nix
    ../../components/programs/bundles/devices.nix
    ../../components/programs/bundles/fonts.nix
    ../../components/programs/bundles/games.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    claude-code
    opencode
  ];

  # Nix dynamic linker
  programs.nix-ld.enable = true;

  # AppImage support
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
}
