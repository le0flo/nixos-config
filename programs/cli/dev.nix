{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    git
    gnumake
    postgresql
    sqlite
  ];
}
