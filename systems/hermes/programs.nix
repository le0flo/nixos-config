{pkgs, ...}:

{
  imports = [
    ../../programs/cli/appimage.nix
    ../../programs/cli/archive.nix
    ../../programs/cli/base.nix
    ../../programs/cli/bash.nix
    ../../programs/cli/dev.nix
    ../../programs/cli/external.nix
    ../../programs/cli/internet.nix

    ../../programs/gui/base.nix
    ../../programs/gui/dev.nix
    ../../programs/gui/internet.nix
    ../../programs/gui/media.nix
    ../../programs/gui/office.nix
    ../../programs/gui/privacy.nix
    ../../programs/gui/style.nix
  ];

  environment.systemPackages = with pkgs; [
    iwgtk
    intel-gpu-tools
    openfortivpn
    opencode
    kubectl
    kubelogin
    azure-cli
    kubernetes-helm
  ];

  nixpkgs.config.allowUnfree = true;
}
