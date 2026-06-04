{pkgs, ...}:

{
  imports = [
    ../../programs/cli/bash.nix
    ../../programs/cli/base.nix
    ../../programs/cli/internet.nix
    ../../programs/cli/external.nix
    ../../programs/cli/appimage.nix

    ../../programs/graphical/base.nix
    ../../programs/graphical/internet.nix
    ../../programs/graphical/dev.nix
    ../../programs/graphical/media.nix
    ../../programs/graphical/office.nix
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
