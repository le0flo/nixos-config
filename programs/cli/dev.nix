{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    git
    gnumake
    postgresql
    sqlite
    kubectl
    kubernetes-helm
  ];
}
