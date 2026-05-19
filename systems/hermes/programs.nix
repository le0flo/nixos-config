{pkgs, ...}:

{
  imports = [
    ../../components/programs/bash.nix

    ../../components/programs/base.nix
    ../../components/programs/internet.nix
    ../../components/programs/external.nix
    ../../components/programs/appimage.nix

    ../../components/programs/graphical/base.nix
    ../../components/programs/graphical/dev.nix
    ../../components/programs/graphical/media.nix
    ../../components/programs/graphical/office.nix
    ../../components/programs/graphical/games.nix
    ../../components/programs/graphical/file-sharing.nix
    ../../components/programs/graphical/social.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    iwgtk
    openfortivpn
    opencode
    kubectl
    kubelogin
    azure-cli
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
}
