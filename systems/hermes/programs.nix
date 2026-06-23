{pkgs, ...}:

{
  imports = [
    ../../programs/cli/bash.nix
    ../../programs/cli/base.nix
    ../../programs/cli/internet.nix
    ../../programs/cli/external.nix
    ../../programs/cli/appimage.nix

    ../../programs/gui/style.nix
    ../../programs/gui/base.nix
    ../../programs/gui/privacy.nix
    ../../programs/gui/internet.nix
    ../../programs/gui/dev.nix
    ../../programs/gui/office.nix
    ../../programs/gui/media.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    iwgtk
    openfortivpn
    codex
    kubectl
    kubelogin
    azure-cli
    kubernetes-helm
  ];
}
